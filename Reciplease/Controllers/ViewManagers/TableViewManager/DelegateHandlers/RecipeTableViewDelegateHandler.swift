//
//  RecipeTableViewDelegateHandler.swift
//  Reciplease
//
//  Created by Canessane Poudja on 02/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class RecipeTableViewDelegateHandler: NSObject, UITableViewDelegate {
    // MARK: - INTERNAL

    // MARK: Inits

    init(
        viewController: UIViewController,
        getRecipeWithImage: @escaping (IndexPath) -> RecipeWithImage,
        willDisplayCell: ((IndexPath) -> Void)?) {

        self.viewController = viewController
        self.getRecipeWithImage = getRecipeWithImage
        self.willDisplayCell = willDisplayCell
    }



    // MARK: Methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentRecipeDetailScreen(indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let willDisplayCell = willDisplayCell else { return }
        willDisplayCell(indexPath)
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private let viewController: UIViewController
    private let willDisplayCell: ((IndexPath) -> Void)?
    private let getRecipeWithImage: (IndexPath) -> RecipeWithImage



    // MARK: Methods

    ///Presents the recipe's detail screen at the given indexPath
    private func presentRecipeDetailScreen(indexPath: IndexPath) {
        guard let detailVC = viewController.storyboard?.instantiateViewController(
            withIdentifier: "RecipeDetailViewController") as? RecipeDetailViewController else { return }

        let recipeWithImage = getRecipeWithImage(indexPath)
        detailVC.recipeWithImage = recipeWithImage
        viewController.navigationController?.pushViewController(detailVC, animated: true)
    }
}
