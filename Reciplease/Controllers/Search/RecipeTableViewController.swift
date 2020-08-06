//
//  RecipeListViewController.swift
//  Reciplease
//
//  Created by Canessane Poudja on 22/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class RecipeTableViewController: UIViewController {
    // MARK: - INTERNAL

    // MARK: Properties

    var foods: [Food]!



    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        setupTableView()
        updateUIWithRecipes()
    }



    // MARK: - PRIVATE

    // MARK: IBOutlets

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noResultView: UIView!



    // MARK: Properties

    private let networkManager = ServiceContainer.recipeNetworkManager
    private let alertManager = ServiceContainer.alertManager
    private let recipeTableViewDataSource = RecipeTableViewDataSource()

    private var startIndexRecipe = 0
    private var shouldIncreaseStartIndexRecipe = false
    private var hasFetchMoreRecipes = true

    private var isTableViewFooterNil: Bool {
        tableView.tableFooterView == nil
    }

    lazy private var recipeTableViewDelegateHandler: RecipeTableViewDelegateHandler = {
        RecipeTableViewDelegateHandler(
            viewController: self,
            getRecipeWithImage: recipeTableViewDataSource.getRecipeWithImageFromArrays(atIndexPath:),
            willDisplayCell: displayLoadMoreCell(indexPath:))
    }()

    ///This button is shown in the tableView's footerView to load more recipes
    lazy private var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 45))
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Load more recipes", for: .normal)
        button.titleLabel?.font = UIFont.avenirNext
        button.backgroundColor = UIColor.customGreen
        activityIndicator.style = .medium
        setConstraints(toSubview: activityIndicator, inSuperview: button)
        return button
    }()

    lazy private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        return activityIndicator
    }()



    // MARK: Methods

    ///Sets the activityIndicator's style, position in the center of view and starts its animation
    private func setupActivityIndicator() {
        activityIndicator.style = .large
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }

    ///Sets the delegate, the dataSource of the tavleView and registers the RecipeTableViewCell
    private func setupTableView() {
        tableView.delegate = recipeTableViewDelegateHandler
        tableView.dataSource = recipeTableViewDataSource
        tableView.register(UINib(nibName: "RecipeTableViewCell", bundle: .main), forCellReuseIdentifier: "recipeCell")
    }

    ///Updates the UI with the downloaded recipes
    @objc private func updateUIWithRecipes() {
        showLoadingIfNeeded()
        let foods = getQueryString()
        increaseStartIndexRecipeIfNeeded()

        networkManager.getRecipes(
        forFoods: foods,
        fromMinIndex: startIndexRecipe,
        toMaxIndex: startIndexRecipe + 50) { [weak self] result in

            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .failure(let networkError):
                    self.presentAlert(message: networkError.message)
                case .success(let recipeObjects):
                    self.handleSuccessfulNetworkFetching(recipeObjects: recipeObjects)
                }
            }

        }
    }

    ///Sets the button tilteColor to .clear and starts the loading animation of activityIndicator
    private func showLoadingIfNeeded() {
        if !isTableViewFooterNil {
            button.setTitleColor(.clear, for: .normal)
            activityIndicator.startAnimating()
        }
    }

    ///Returns a String build by appending all food's name contained in foods
    private func getQueryString() -> String {
        var foods = ""
        self.foods.forEach { if let name = $0.name { foods.append(name + "+") } }
        foods = String(foods.dropLast())
        return foods
    }

    ///Increases startIndexRecipe of 50 according to shouldIncreaseStartIndexRecipe
    private func increaseStartIndexRecipeIfNeeded() {
        if shouldIncreaseStartIndexRecipe {
            startIndexRecipe += 50
            shouldIncreaseStartIndexRecipe = false
        }
    }

    /**Sets hasFetchMoreRecipes according the given recipeObjects array,
    display noResultView if needed, populates recipeTableViewDataSource.recipes
    with recipesObjects and downloads the recipes' images*/
    private func handleSuccessfulNetworkFetching(recipeObjects: ([RecipeObject])) {
        hasFetchMoreRecipes = !recipeObjects.isEmpty
        if hasToDisplayNoResultView(recipeObjects: recipeObjects) { return }
        recipeTableViewDataSource.recipes += recipeObjects
        recipeObjects.forEach { downloadRecipeImage(recipe: $0) }
    }

    ///Returns true if noResultView should be displayed and hides tableView if needed
    private func hasToDisplayNoResultView(recipeObjects: [RecipeObject]) -> Bool {
        if recipeObjects.isEmpty && recipeTableViewDataSource.recipes.isEmpty {
            tableView.isHidden = true
            setConstraints(toSubview: noResultView, inSuperview: view)
            return true
        }
        return false
    }

    ///Dowloads the image corresponding to the given RecipeObject
    ///and populates recipeTableViewDataSource.images with it
    private func downloadRecipeImage(recipe: RecipeObject) {
        self.networkManager.getRecipeImage(fromImageUrlString: recipe.imageUrl) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .failure(let networkError):
                    self.presentAlert(message: "\(networkError.message)")
                case .success(let imageData):
                    self.populateImages(fromData: imageData, forRecipe: recipe)
                }
            }
        }
    }

    ///Converts the given Data into a UIImage and inserts it
    ///in recipeTableViewDataSource.images at the given recipe's name key
    private func populateImages(fromData data: Data, forRecipe recipe: RecipeObject) {
        guard let image = UIImage(data: data) else {
            recipeTableViewDataSource.images[recipe.name] = UIImage.defaultRecipeImage
            return
        }

        recipeTableViewDataSource.images[recipe.name] = image
        activityIndicator.stopAnimating()
        tableView.reloadData()
    }

    ///Sets the given subview in the center of the given superview
    private func setConstraints(toSubview subview: UIView, inSuperview superview: UIView) {
        superview.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        subview.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
    }

    ///Displays "Load more recipes" cell if needed
    private func displayLoadMoreCell(indexPath: IndexPath) {
        let shouldDisplayLoadMoreCell = getShouldDisplayLoadMoreCell(indexPath: indexPath)
        shouldDisplayLoadMoreCell ? setupTableViewFooter() : removeTableViewFooter()
    }

    ///Returns true if the "Load more recipe" cell shoud be displayed
    private func getShouldDisplayLoadMoreCell(indexPath: IndexPath) -> Bool {
        let shouldDisplayLoadMoreCell =
            indexPath.row == recipeTableViewDataSource.recipes.count - 1
            && startIndexRecipe < 50
            && tableView.tableFooterView == nil
            && recipeTableViewDataSource.recipes.count > 49
            && hasFetchMoreRecipes
        return shouldDisplayLoadMoreCell
    }

    ///Sets the tableView's footerView to the button and shouldIncreaseStartIndexRecipe to true
    private func setupTableViewFooter() {
        tableView.tableFooterView = button
        shouldIncreaseStartIndexRecipe = true
        button.addTarget(self, action: #selector(updateUIWithRecipes), for: .touchUpInside)
    }

    ///Sets the tableView's footerView to nil if it exists
    private func removeTableViewFooter() {
        if !isTableViewFooterNil { tableView.tableFooterView = nil }
    }

    ///Presents an alert with the given message
    private func presentAlert(message: String) {
        alertManager.presentErrorAlert(with: message, presentingViewController: self)
        activityIndicator.stopAnimating()
    }
}
