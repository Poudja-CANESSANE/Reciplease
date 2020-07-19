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

    lazy private var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 45))
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Load more recipes", for: .normal)
        button.titleLabel?.font = UIFont.avenirNext
        button.backgroundColor = UIColor.customGreen
        setConstraints(toSubview: self.activityIndicator, inSuperview: button)
        return button
    }()

    lazy private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        return activityIndicator
    }()



    // MARK: Methods

    private func setupTableView() {
        tableView.delegate = recipeTableViewDelegateHandler
        tableView.dataSource = recipeTableViewDataSource
        tableView.register(UINib(nibName: "RecipeTableViewCell", bundle: .main), forCellReuseIdentifier: "recipeCell")
    }

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

    private func showLoadingIfNeeded() {
        if !isTableViewFooterNil {
            button.setTitleColor(.clear, for: .normal)
            activityIndicator.startAnimating()
        }
    }

    private func getQueryString() -> String {
        var foods = ""
        self.foods.forEach { if let name = $0.name { foods.append(name + "+") } }
        foods = String(foods.dropLast())
        return foods
    }

    private func increaseStartIndexRecipeIfNeeded() {
        if shouldIncreaseStartIndexRecipe {
            startIndexRecipe += 50
            shouldIncreaseStartIndexRecipe = false
        }
    }

    private func handleSuccessfulNetworkFetching(recipeObjects: ([RecipeObject])) {
        hasFetchMoreRecipes = !recipeObjects.isEmpty
        if hasToDisplayNoResultView(recipeObjects: recipeObjects) { return }
        recipeTableViewDataSource.recipes += recipeObjects
        recipeObjects.forEach { downloadRecipeImage(recipe: $0) }
    }

    private func hasToDisplayNoResultView(recipeObjects: [RecipeObject]) -> Bool {
        if recipeObjects.isEmpty && recipeTableViewDataSource.recipes.isEmpty {
            tableView.isHidden = true
            setConstraints(toSubview: noResultView, inSuperview: view)
            return true
        }
        return false
    }

    private func downloadRecipeImage(recipe: RecipeObject) {
        self.networkManager.getRecipeImage(fromImageString: recipe.imageUrl) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .failure(let networkError):
                    self.presentAlert(message: networkError.message)
                case .success(let imageData):
                    self.populateImages(fromData: imageData, forRecipe: recipe)
                }
            }
        }
    }

    private func populateImages(fromData data: Data, forRecipe recipe: RecipeObject) {
        guard let image = UIImage(data: data) else {
            recipeTableViewDataSource.images[recipe.name] = UIImage.defaultRecipeImage
            return
        }

        recipeTableViewDataSource.images[recipe.name] = image
        stopLoadingIfNeeded()
        tableView.reloadData()
    }

    private func stopLoadingIfNeeded() {
        if !isTableViewFooterNil { activityIndicator.stopAnimating() }
    }

    private func setConstraints(toSubview subview: UIView, inSuperview superview: UIView) {
        superview.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        subview.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
    }

    private func displayLoadMoreCell(indexPath: IndexPath) {
        let shouldDisplayLoadMoreCell = getShouldDisplayLoadMoreCell(indexPath: indexPath)
        shouldDisplayLoadMoreCell ? setupTableViewFooter() : removeTableViewFooter()
    }

    private func getShouldDisplayLoadMoreCell(indexPath: IndexPath) -> Bool {
        let shouldDisplayLoadMoreCell =
            indexPath.row == recipeTableViewDataSource.recipes.count - 1
            && startIndexRecipe < 50
            && tableView.tableFooterView == nil
            && recipeTableViewDataSource.recipes.count > 49
            && hasFetchMoreRecipes
        return shouldDisplayLoadMoreCell
    }

    private func setupTableViewFooter() {
        tableView.tableFooterView = button
        shouldIncreaseStartIndexRecipe = true
        button.addTarget(self, action: #selector(updateUIWithRecipes), for: .touchUpInside)
    }

    private func removeTableViewFooter() {
        if !isTableViewFooterNil { tableView.tableFooterView = nil }
    }

    private func presentAlert(message: String) {
        alertManager.presentErrorAlert(with: message, presentingViewController: self)
    }
}
