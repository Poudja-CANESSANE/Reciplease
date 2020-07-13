//
//  RecipeTableViewDataSource.swift
//  Reciplease
//
//  Created by Canessane Poudja on 02/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class RecipeTableViewDataSource: NSObject, UITableViewDataSource {
    // MARK: - INTERNAL

    // MARK: Properties

    var recipes: [RecipeObject] = []
    var images: [String: UIImage] = [:]



    // MARK: Methods
    
    func getRecipeWithImageFromArrays(atIndexPath indexPath: IndexPath) -> RecipeWithImage {
        let recipe = recipes[indexPath.row]

        guard let image = images[recipe.name] else {
            return RecipeWithImage(recipe: recipe, image: UIImage.defaultRecipeImage)
        }

        let recipeWithImage = RecipeWithImage(recipe: recipe, image: image)
        return recipeWithImage
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "recipeCell", for: indexPath) as? RecipeTableViewCell else { return UITableViewCell() }

        let recipeWithImage = getRecipeWithImageFromArrays(atIndexPath: indexPath)
        cell.updateCell(withRecipe: recipeWithImage.recipe, image: recipeWithImage.image)
        return cell
    }
}
