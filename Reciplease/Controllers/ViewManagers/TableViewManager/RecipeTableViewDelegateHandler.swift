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

    // MARK: Properties

    private let viewController: UIViewController
    private let willDisplayCell: ((IndexPath) -> Void)?
    private let getRecipeWithImage: (IndexPath) -> RecipeWithImage



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
        guard let detailVC = viewController.storyboard?.instantiateViewController(
            withIdentifier: "RecipeDetailViewController") as? RecipeDetailViewController else { return }

        let recipeWithImage = getRecipeWithImage(indexPath)
        detailVC.recipeWithImage = recipeWithImage
        viewController.navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let willDisplayCell = willDisplayCell else { return }
        willDisplayCell(indexPath)
    }
}
