//
//  FavoriteViewController.swift
//  Reciplease
//
//  Created by Canessane Poudja on 22/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UIViewController {
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



    // MARK: - PRIVATE

    // MARK: IBOutlets

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noFavoritesRecipesView: UIView!
    


    // MARK: Properties

    private let favoritesTableViewDataSource = FavoritesTableViewDataSource()

    lazy private var favoritesTableViewDelegateHandler: RecipeTableViewDelegateHandler = {
        RecipeTableViewDelegateHandler(
            viewController: self,
            getRecipeWithImage: favoritesTableViewDataSource.getRecipeWithImage(indexPath:),
            willDisplayCell: nil)
    }()



    // MARK: Methods

    ///Sets the delegate, the dataSource of the tavleView and registers the RecipeTableViewCell
    private func setupTableView() {
        tableView.dataSource = favoritesTableViewDataSource
        tableView.delegate = favoritesTableViewDelegateHandler
        tableView.register(UINib(nibName: "RecipeTableViewCell", bundle: .main), forCellReuseIdentifier: "recipeCell")
    }

    ///Displays noFavoriteRecipesView if there is no favorite recipe saved in Core Data
    private func displayNoFavoriteRecipesViewIfNeeded() {
        let ifNoFavorites = favoritesTableViewDataSource.favoriteRecipes.isEmpty
        tableView.backgroundView = ifNoFavorites ? noFavoritesRecipesView : nil
    }
}
