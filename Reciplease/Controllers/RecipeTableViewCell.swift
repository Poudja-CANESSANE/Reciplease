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

    func updateCell(withRecipe recipe: RecipeObject) {
//        recipeImageView.image = recipe.hits[0].recipe.image
        recipeNameLabel.text = recipe.name
        ingredientsLabel.text = recipe.ingredientLines[0]
        timeLabel.text = String(recipe.time)
    }



    // MARK: - PRIVATE

    // MARK: IBOutlets

    @IBOutlet private weak var recipeImageView: UIImageView!
    @IBOutlet private weak var recipeNameLabel: UILabel!
    @IBOutlet private weak var ingredientsLabel: UILabel!
    @IBOutlet private weak var numberOfLikesLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
}
