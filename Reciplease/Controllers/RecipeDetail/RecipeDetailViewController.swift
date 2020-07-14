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
        addNotificationObserver()
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
        NotificationCenter.default.post(name: .favoriteStateDidChange, object: nil)
    }



    // MARK: Properties

    private let alertManager = ServiceContainer.alertManager
    private let favoriteRecipeDataManager = ServiceContainer.favoriteRecipeDataManager



    // MARK: Methods

    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setFavoriteBarButtonItemImage),
            name: .favoriteStateDidChange,
            object: nil)
    }

    private func setUI() {
        setFavoriteBarButtonItemImage()
        nameLabel.text = recipeWithImage.recipe.name
        imageView.image = recipeWithImage.image
        caloriesLabel.text = recipeWithImage.recipe.calories + " kcal"
        timeLabel.text = recipeWithImage.recipe.time
        yieldsLabel.text = recipeWithImage.recipe.yield + " yields"
        textView.text = recipeWithImage.recipe.ingredientLines
    }

    @objc private func setFavoriteBarButtonItemImage() {
         favoriteBarButtonItem.image = favoriteRecipeDataManager.isFavorite(recipeUrl: recipeWithImage.recipe.url)
            ? UIImage.starFillImage : UIImage.starImage
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
        return favoriteBarButtonItem.image == UIImage.starImage ? addRecipeToFavorite() : removeRecipeFromFavorite()
    }

    private func addRecipeToFavorite() {
        do {
            try favoriteRecipeDataManager.save(recipeWithImage)
        } catch {
            presentAlert(message: "The saving of \(recipeWithImage.recipe.name) is impossible !")
        }
        favoriteBarButtonItem.image = UIImage.starFillImage
    }

    private func removeRecipeFromFavorite() {
        favoriteRecipeDataManager.deleteFavoriteRecipe(withUrl: recipeWithImage.recipe.url)
        favoriteBarButtonItem.image = UIImage.starImage
    }

    private func presentAlert(message: String) {
        alertManager.presentErrorAlert(with: message, presentingViewController: self)
    }
}
