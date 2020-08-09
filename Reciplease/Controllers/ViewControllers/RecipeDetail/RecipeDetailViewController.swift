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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setFavoriteBarButtonItemImage()
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
    private let favoriteRecipeDataManager = ServiceContainer.favoriteRecipeDataManager



    // MARK: Methods

    ///Sets the UI with recipeWithImage
    private func setUI() {
        nameLabel.text = recipeWithImage.recipe.name
        imageView.image = recipeWithImage.image
        caloriesLabel.text = recipeWithImage.recipe.calories + " kcal"
        timeLabel.text = recipeWithImage.recipe.time
        yieldsLabel.text = recipeWithImage.recipe.yield + " yields"
        textView.text = recipeWithImage.recipe.ingredientLines
    }

    ///Sets the favoriteBarButtonItem's image according to the presence of recipeWithImage in Core Data
    private func setFavoriteBarButtonItemImage() {
        do {
            favoriteBarButtonItem.image =
                try favoriteRecipeDataManager.isFavorite(recipeUrl: recipeWithImage.recipe.url)
            ? UIImage.starFillImage : UIImage.starImage
        } catch { presentAlert(message: CoreDataError.getErrorWhileFetchingFromCoreData.message) }
    }

    ///Presents a SFSafariViewController with the given url
    private func presentSafariPage(withUrlString urlString: String) {
        guard let url = URL(string: urlString) else {
            presentAlert(message: "Cannot unwrap URL to show recipe directions!")
            return
        }

        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }

    ///Saves or removes recipeWithImage in Core Data according to the favoriteBarButtonItem's image
    private func addOrRemoveRecipeFromFavorite() {
        return favoriteBarButtonItem.image == UIImage.starImage ? addRecipeToFavorite() : removeRecipeFromFavorite()
    }

    ///Saves the RecipeWithImage in Core Data and sets the favoriteBarButtonItem's image to UIImage.starFillImage
    private func addRecipeToFavorite() {
        do {
            try favoriteRecipeDataManager.save(recipeWithImage)
        } catch {
            presentAlert(message: CoreDataError.recipeWithImageSavingIsImpossible.message)
        }
        favoriteBarButtonItem.image = UIImage.starFillImage
    }

    ///Removes the FavoriteRecipe from Core Data and sets the favoriteBarButtonItem's image to UIImage.starImage
    private func removeRecipeFromFavorite() {
        do {
            try favoriteRecipeDataManager.deleteFavoriteRecipe(withUrl: recipeWithImage.recipe.url)
        } catch {
            presentAlert(message: CoreDataError.favoriteRecipeDeletingIsImpossible.message)
        }
        favoriteBarButtonItem.image = UIImage.starImage
    }

    ///Presents an alert with the given message
    private func presentAlert(message: String) {
        alertManager.presentErrorAlert(with: message, presentingViewController: self)
    }
}
