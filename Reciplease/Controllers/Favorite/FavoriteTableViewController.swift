//
//  FavoriteViewController.swift
//  Reciplease
//
//  Created by Canessane Poudja on 22/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class FavoriteTableViewController: UIViewController {
    // MARK: - INTERNAL

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        displayNoFavoriteRecipesViewIfNeeded()
    }

    // MARK: IBOutlets

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noFavoriteRecipesView: UIView!
    


    // MARK: Properties
    private let alertManager = ServiceContainer.alertManager
    private let favoriteTableViewDataSource = FavoriteTableViewDataSource()

    lazy private var favoriteRecipeTableViewDelegateHandler: RecipeTableViewDelegateHandler = {
        RecipeTableViewDelegateHandler(
            viewController: self,
            getRecipeWithImage: favoriteTableViewDataSource.getRecipeWithImage(indexPath:),
            willDisplayCell: nil)
    }()



    // MARK: Methods

    private func setupTableView() {
        tableView.dataSource = favoriteTableViewDataSource
        tableView.delegate = favoriteRecipeTableViewDelegateHandler
        tableView.register(UINib(nibName: "RecipeTableViewCell", bundle: .main), forCellReuseIdentifier: "recipeCell")
    }

    private func displayNoFavoriteRecipesViewIfNeeded() {
        let ifNoFavorite = favoriteTableViewDataSource.favoriteRecipes.isEmpty
        tableView.backgroundView = ifNoFavorite ? noFavoriteRecipesView : nil
    }

    private func presentAlert(message: String) {
        alertManager.presentErrorAlert(with: message, presentingViewController: self)
    }
}
