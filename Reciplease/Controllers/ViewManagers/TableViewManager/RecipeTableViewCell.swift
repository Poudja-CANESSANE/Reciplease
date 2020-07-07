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
    }

    // MARK: Methods

    func updateCell(withRecipe recipe: RecipeObject, image: UIImage) {
        recipeImageView.image = image
        recipeNameLabel.text = recipe.name

        let ingredientsPreview = getIngredientsPreview(fromRecipe: recipe)
        ingredientsLabel.text = ingredientsPreview

        caloriesLabel.text = recipe.calories + "kcal"
        timeLabel.text = recipe.time
        yieldsLabel.text = "\(Int(recipe.yield)) yields"
    }



    // MARK: - PRIVATE

    // MARK: IBOutlets

    @IBOutlet private weak var recipeImageView: UIImageView!
    @IBOutlet private weak var recipeNameLabel: UILabel!
    @IBOutlet private weak var ingredientsLabel: UILabel!
    @IBOutlet private weak var caloriesLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var yieldsLabel: UILabel!



    // MARK: Methods

    private func getIngredientsPreview(fromRecipe recipe: RecipeObject) -> String {
        var ingredientsPreview = ""
        let upperBound = getIngredientsUpperBound(fromRecipe: recipe)
        for index in 0...upperBound {
            ingredientsPreview += recipe.ingredientLines[index] + ", "
        }
        ingredientsPreview.removeLast(2)
        return ingredientsPreview
    }

    private func getIngredientsUpperBound(fromRecipe recipe: RecipeObject) -> Int {
        let upperBound = recipe.ingredientLines.count - 1 < 3 ? recipe.ingredientLines.count - 1 : 3
        return upperBound
    }
}
