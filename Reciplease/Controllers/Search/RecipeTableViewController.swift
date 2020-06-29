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
        tableView.refreshControl = refresher
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

    lazy private var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.gray
        refreshControl.addTarget(self, action: #selector(updateUIWithRecipes), for: .valueChanged)
        return refreshControl
    }()

    private var recipes: [RecipeObject] = []
    private var images: [String: UIImage] = [:]



    // MARK: Methods

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
        Food.all.forEach {
            if let name = $0.name {
                foods.append(name + "+")
            }
        }

        foods = String(foods.dropLast())
        return foods
    }

    private func handleSuccessfulNetworkFetching(recipeObjects: ([RecipeObject])) {
        self.recipes = recipeObjects
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
            images[recipe.name] = UIImage(named: "defaultRecipeImage")
            return
        }

        images[recipe.name] = image
        refresher.endRefreshing()
        tableView.reloadData()
    }

    private func getDataFromArrays(at indexPath: IndexPath) -> (recipe: RecipeObject, image: UIImage) {
        let recipe = recipes[indexPath.row]
        guard let image = images[recipe.name] else { return (recipe: recipe, image: UIImage()) }
        return (recipe: recipe, image: image)
    }

    private func presentAlert(message: String) {
        alertManager.presentErrorAlert(with: message, presentingViewController: self)
    }
}

extension RecipeTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let recipes = recipes else { return 1 }
        return recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "recipeCell", for: indexPath) as? RecipeTableViewCell else { return UITableViewCell() }

        let data = getDataFromArrays(at: indexPath)

        cell.updateCell(withRecipe: data.recipe, image: data.image)

//        if indexPath.row == self.recipes.count - 1 {
//            self.loadMore()
//        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "RecipeDetailViewController")
            as? RecipeDetailViewController else { return }

        let data = getDataFromArrays(at: indexPath)

        detailVC.recipe = data.recipe
        detailVC.image = data.image

        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension RecipeTableViewController: UITableViewDelegate {}
