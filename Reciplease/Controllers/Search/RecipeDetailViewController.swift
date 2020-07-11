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



    // MARK: IBActions

    @IBAction func didTapGetDirectionsButton(_ sender: RoundedButton) {
        presentSafariPage(withUrlString: recipeWithImage.recipe.url)
    }



    // MARK: Properties

    private let alertManager = AlertManager()



    // MARK: Methods

    private func setUI() {
        nameLabel.text = recipeWithImage.recipe.name
        imageView.image = recipeWithImage.image
        caloriesLabel.text = recipeWithImage.recipe.calories + " kcal"
        timeLabel.text = recipeWithImage.recipe.time
        yieldsLabel.text = "\(Int(recipeWithImage.recipe.yield)) yields"
        let ingredients = getIngredients()
        textView.text = ingredients
    }

    private func getIngredients() -> String {
        var ingredients = ""
        recipeWithImage.recipe.ingredientLines.forEach { ingredients.append(contentsOf: "- " + $0 + "\n") }
        print(ingredients)
        return ingredients
    }

    private func presentSafariPage(withUrlString urlString: String) {
        print(urlString)
        guard let url = URL(string: urlString) else {
            presentAlert(message: "Cannot unwrap URL !")
            return
        }

        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }

    private func presentAlert(message: String) {
        alertManager.presentErrorAlert(with: message, presentingViewController: self)
    }
}
