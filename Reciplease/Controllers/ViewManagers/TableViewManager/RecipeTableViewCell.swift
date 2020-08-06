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

    // MARK: Methods

    ///Updates the cell with the given RecipeWithImage
    func updateCell(withRecipeWithImage recipeWithImage: RecipeWithImage) {
        recipeImageView.image = recipeWithImage.image
        recipeNameLabel.text = recipeWithImage.recipe.name

        let ingredientsPreview = getIngredientsPreview(fromRecipe: recipeWithImage.recipe)
        ingredientsLabel.text = ingredientsPreview

        caloriesLabel.text = recipeWithImage.recipe.calories + " kcal"
        timeLabel.text = recipeWithImage.recipe.time
        yieldsLabel.text = recipeWithImage.recipe.yield + " yields"
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

    ///Returns a String corresponding to the ingredients preview build from the given RecipeObject
    private func getIngredientsPreview(fromRecipe recipe: RecipeObject) -> String {
        let ingredientsArray = getIngredientsArray(fromRecipe: recipe)
        let upperBound = getUpperBound(fromIngredientsArray: ingredientsArray)

        let ingredientsPreview = assignValueToIngredientsPreview(
            fromIngredientsArray: ingredientsArray,
            upperBound: upperBound)

        return ingredientsPreview
    }

    ///Returns an array of String from the given recipe.ingredientLines
    private func getIngredientsArray(fromRecipe recipe: RecipeObject) -> [String] {
        let ingredientsString = recipe.ingredientLines.replacingOccurrences(of: "- ", with: "")
        let ingredientsArray = ingredientsString.components(separatedBy: "\n")
        return ingredientsArray
    }

    ///Returns an Int corresponding to the upper bound (between 1 and 3) of the given array
    private func getUpperBound(fromIngredientsArray ingredientsArray: [String]) -> Int {
        let upperBound = ingredientsArray.count - 1 < 3 ? ingredientsArray.count - 1 : 3
        return upperBound
    }

    ///Returns a String corresponding to the ingredients preview
    private func assignValueToIngredientsPreview(
        fromIngredientsArray ingredientsArray: [String],
        upperBound: Int) -> String {

        var ingredientsPreview = ""
        for index in 0...upperBound { ingredientsPreview += ingredientsArray[index] + ", " }
        ingredientsPreview.removeLast(2)
        return ingredientsPreview
    }
}
