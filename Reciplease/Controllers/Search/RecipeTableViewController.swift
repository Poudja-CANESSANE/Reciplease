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

    private let netwokManager = RecipeNetworkManager(
        networkService: NetworkServiceImplementation(),
        urlProvider: UrlProviderImplementation())
    private let alertManager = AlertManager()
    private let recipeTableViewDataSource = RecipeTableViewDataSource()

    private var startIndexRecipe = 0
    private var shouldIncreaseStartIndexRecipe = false
    private var hasFetchMoreRecipes = true

    lazy private var  recipeTableViewDelegateHandler: RecipeTableViewDelegateHandler = {
        let recipeTableViewDelegateHandler = RecipeTableViewDelegateHandler(
            didSelectRow: presentRecipeDetailScreen(indexPath:),
            willDisplayCell: displayLoadMoreCell(indexPath:))
        return recipeTableViewDelegateHandler
    }()

    lazy private var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 45))
        button.setTitleColor(.blue, for: .normal)
        button.setTitle("Load more recipes", for: .normal)
        return button
    }()



    // MARK: Methods

    private func setupTableView() {
        tableView.delegate = recipeTableViewDelegateHandler
        tableView.dataSource = recipeTableViewDataSource
    }

    @objc private func updateUIWithRecipes() {
        let foods = getQueryString()
        increaseStartIndexRecipeIfNeeded()

        netwokManager.getRecipes(
        forFoods: foods,
        fromMinIndex: startIndexRecipe,
        toMaxIndex: startIndexRecipe + 50) { [weak self] result in

            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .failure(let networkError):
                    self.presentAlert(message: networkError.message)
                case .success(let recipeObjects):
                    print(recipeObjects.count)
                    self.handleSuccessfulNetworkFetching(recipeObjects: recipeObjects)
                }
            }

        }
    }

    private func getQueryString() -> String {
        var foods = ""
        Food.all.forEach { if let name = $0.name { foods.append(name + "+") } }
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
            setNoResultViewConstraints()
            return true
        }
        return false
    }

    private func setNoResultViewConstraints() {
        view.addSubview(noResultView)
        noResultView.translatesAutoresizingMaskIntoConstraints = false
        noResultView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        noResultView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    private func downloadRecipeImage(recipe: RecipeObject) {
        self.netwokManager.getRecipeImage(fromImageString: recipe.imageUrl) { [weak self] result in
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
            recipeTableViewDataSource.images[recipe.name] = UIImage(named: "defaultRecipeImage")
            return
        }

        recipeTableViewDataSource.images[recipe.name] = image
        tableView.reloadData()
    }

    private func presentRecipeDetailScreen(indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "RecipeDetailViewController")
            as? RecipeDetailViewController else { return }

        guard let recipeWithImage = recipeTableViewDataSource.getRecipeWithImageFromArrays(at: indexPath)
            else { return }

        detailVC.recipe = recipeWithImage.recipe
        detailVC.image = recipeWithImage.image

        navigationController?.pushViewController(detailVC, animated: true)
    }

    private func displayLoadMoreCell(indexPath: IndexPath) {
        print("\(recipeTableViewDataSource.recipes.count) \(indexPath.row)")
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
        if tableView.tableFooterView != nil {
                tableView.tableFooterView = nil
        }
    }

    private func presentAlert(message: String) {
        alertManager.presentErrorAlert(with: message, presentingViewController: self)
    }
}
