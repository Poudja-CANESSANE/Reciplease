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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUIWithRecipes()
    }



    // MARK: - PRIVATE

    // MARK: IBOutlets

    @IBOutlet private weak var tableView: UITableView!



    // MARK: Properties

    private let netwokManager = RecipeNetworkManager(
        networkService: NetworkServiceImplementation(),
        urlProvider: UrlProviderImplementation())
    private let alertManager = AlertManager()
    private let recipeTableViewDataSource = RecipeTableViewDataSource()

    lazy private var  recipeTableViewDelegateHandler: RecipeTableViewDelegateHandler = {
        let recipeTableViewDelegateHandler = RecipeTableViewDelegateHandler(
            didSelectRow: presentRecipeDetailScreen(indexPath:))
        return recipeTableViewDelegateHandler
    }()

    lazy private var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.gray
        refreshControl.addTarget(self, action: #selector(updateUIWithRecipes), for: .valueChanged)
        return refreshControl
    }()

    



    // MARK: Methods

    private func setupTableView() {
        tableView.delegate = recipeTableViewDelegateHandler
        tableView.dataSource = recipeTableViewDataSource
        tableView.refreshControl = refresher
    }

    @objc private func updateUIWithRecipes() {
        let foods = getQueryString()

        netwokManager.getRecipes(forFoods: foods) { [weak self] result in
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
        Food.all.forEach { if let name = $0.name { foods.append(name + "+") }}
        foods = String(foods.dropLast())
        return foods
    }

    private func handleSuccessfulNetworkFetching(recipeObjects: ([RecipeObject])) {
        recipeTableViewDataSource.recipes = recipeObjects
        recipeObjects.forEach { downloadRecipeImage(recipe: $0) }
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
        refresher.endRefreshing()
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

    private func presentAlert(message: String) {
        alertManager.presentErrorAlert(with: message, presentingViewController: self)
    }
}
