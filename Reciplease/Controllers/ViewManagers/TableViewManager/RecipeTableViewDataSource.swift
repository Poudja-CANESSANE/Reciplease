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
    
    func getRecipeWithImageFromArrays(at indexPath: IndexPath) -> RecipeWithImage? {
        let recipe = recipes[indexPath.row]
        guard let image = images[recipe.name] else { return nil }
        let recipeWithImage = RecipeWithImage(recipe: recipe, image: image)
        return recipeWithImage
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        guard let recipes = recipes else { return 1 }
            return recipes.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "recipeCell", for: indexPath) as? RecipeTableViewCell else { return UITableViewCell() }

            guard let data = getRecipeWithImageFromArrays(at: indexPath) else { return UITableViewCell() }

            cell.updateCell(withRecipe: data.recipe, image: data.image)
            return cell
        }
}
