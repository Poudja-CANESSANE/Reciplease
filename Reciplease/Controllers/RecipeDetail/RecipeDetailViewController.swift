//
//  RecipeDetailViewController.swift
//  Reciplease
//
//  Created by Canessane Poudja on 22/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit
import SafariServices

class RecipeDetailViewController: UIViewController {
    // MARK: - INTERNAL

    // MARK: Properties

    var recipeWithImage: RecipeWithImage!



    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }


    // MARK: - PRIVATE

    // MARK: IBOutlets

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var caloriesLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var yieldsLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var favoriteBarButtonItem: UIBarButtonItem!



    // MARK: IBActions

    @IBAction private func didTapGetDirectionsButton(_ sender: RoundedButton) {
        presentSafariPage(withUrlString: recipeWithImage.recipe.url)
    }

    @IBAction private func didTapFavoriteBarButtonItem(_ sender: UIBarButtonItem) {
        addOrRemoveRecipeFromFavorite()
    }


    // MARK: Properties

    private let alertManager = ServiceContainer.alertManager
    private let starFillImage = UIImage(systemName: "star.fill")
    private let starImage = UIImage(systemName: "star")



    // MARK: Methods

    private func setUI() {
        setFavoriteBarButtonItemImage()
        nameLabel.text = recipeWithImage.recipe.name
        imageView.image = recipeWithImage.image
        caloriesLabel.text = recipeWithImage.recipe.calories + " kcal"
        timeLabel.text = recipeWithImage.recipe.time
        yieldsLabel.text = recipeWithImage.recipe.yield + " yields"
        textView.text = recipeWithImage.recipe.ingredientLines
    }

    private func setFavoriteBarButtonItemImage() {
         favoriteBarButtonItem.image = FavoriteRecipe.isFavorite(recipeUrl: recipeWithImage.recipe.url)
         ? starFillImage : starImage
    }

    private func presentSafariPage(withUrlString urlString: String) {
        guard let url = URL(string: urlString) else {
            presentAlert(message: "Cannot unwrap URL !")
            return
        }

        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }

    private func addOrRemoveRecipeFromFavorite() {
        return favoriteBarButtonItem.image == starImage ? addRecipeToFavorite() : removeRecipeFromFavorite()
    }

    private func addRecipeToFavorite() {
        let favoriteRecipe = FavoriteRecipe(context: AppDelegate.viewContext)
        favoriteRecipe.name = recipeWithImage.recipe.name
        favoriteRecipe.calories = recipeWithImage.recipe.calories
        favoriteRecipe.ingredientLines = recipeWithImage.recipe.ingredientLines
        favoriteRecipe.time = recipeWithImage.recipe.time
        favoriteRecipe.url = recipeWithImage.recipe.url
        favoriteRecipe.yield = recipeWithImage.recipe.yield
        favoriteRecipe.image = recipeWithImage.image.pngData()
        
        FavoriteRecipe.save(recipe: favoriteRecipe)
        favoriteBarButtonItem.image = starFillImage
    }

    private func removeRecipeFromFavorite() {
        FavoriteRecipe.deleteFavoriteRecipe(withUrl: recipeWithImage.recipe.url)
        favoriteBarButtonItem.image = starImage
    }

    private func presentAlert(message: String) {
        alertManager.presentErrorAlert(with: message, presentingViewController: self)
    }
}
