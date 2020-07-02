//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Canessane Poudja on 22/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    // MARK: - INTERNAL

    // MARK: Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        addBottomGradient()
    }

    // MARK: Methods

    func updateCell(withRecipe recipe: RecipeObject, image: UIImage) {
        recipeImageView.image = image
        recipeNameLabel.text = recipe.name
        let ingredientsPreview = getIngredientsPreview(fromRecipe: recipe)
        ingredientsLabel.text = ingredientsPreview
        caloriesLabel.text = recipe.calories + "kcal"
        timeLabel.text = recipe.time
    }



    // MARK: - PRIVATE

    // MARK: IBOutlets

    @IBOutlet private weak var recipeImageView: UIImageView!
    @IBOutlet private weak var recipeNameLabel: UILabel!
    @IBOutlet private weak var ingredientsLabel: UILabel!
    @IBOutlet private weak var caloriesLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!



    // MARK: Methods

    private func getIngredientsPreview(fromRecipe recipe: RecipeObject) -> String {
        var ingredientsPreview = ""
        let upperBound = recipe.ingredientLines.count - 1 < 3 ? recipe.ingredientLines.count - 1 : 3
        for index in 0...upperBound {
            ingredientsPreview += recipe.ingredientLines[index] + ", "
        }
        ingredientsPreview.removeLast(2)
        return ingredientsPreview
    }

    private func addBottomGradient() {
        let gradient = getGradient()
        insertSublayers(gradient: gradient)
    }

    private func getGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 0, y: 0)
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: frame.height)
        return gradient
    }

    private func insertSublayers(gradient: CAGradientLayer) {
       layer.insertSublayer(gradient, above: recipeImageView.layer)
       layer.insertSublayer(recipeNameLabel.layer, above: layer)
       layer.insertSublayer(ingredientsLabel.layer, above: layer)
   }
}
