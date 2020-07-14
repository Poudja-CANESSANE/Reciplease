//
//  FavoriteTableViewDataSource.swift
//  Reciplease
//
//  Created by Canessane Poudja on 13/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class FavoriteTableViewDataSource: NSObject, UITableViewDataSource {
    // MARK: - INTERNAL

    // MARK: Properties

    var favoriteRecipes: [FavoriteRecipe] { favoriteRecipeDataManager.getAll() }



    // MARK: Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "recipeCell", for: indexPath) as? RecipeTableViewCell else { return UITableViewCell() }

        let recipeWithImage = getRecipeWithImage(indexPath: indexPath)

        cell.updateCell(withRecipe: recipeWithImage.recipe, image: recipeWithImage.image)

        return cell
    }

    func getRecipeWithImage(indexPath: IndexPath) -> RecipeWithImage {
        let favoriteRecipe = favoriteRecipes[indexPath.row]
        let recipe = getRecipeObject(fromFavoriteRecipe: favoriteRecipe)
        let image = getImage(fromFavoriteRecipe: favoriteRecipe)
        let recipeWithImage = RecipeWithImage(recipe: recipe, image: image)
        return recipeWithImage
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private let favoriteRecipeDataManager = ServiceContainer.favoriteRecipeDataManager

    // MARK: Methods

    private func getRecipeObject(fromFavoriteRecipe favoriteRecipe: FavoriteRecipe) -> RecipeObject {
        let recipe = RecipeObject(
        imageUrl: "",
        name: favoriteRecipe.name ?? "N/A",
        time: favoriteRecipe.time ?? "N/A",
        calories: favoriteRecipe.calories ?? "N/A",
        url: favoriteRecipe.url ??
            "http://www.edamam.com/ontologies/edamam.owl#recipe_66d98ceff7f11dd47094e80903f4a942",
        ingredientLines: favoriteRecipe.ingredientLines ?? "N/A",
        yield: favoriteRecipe.yield ?? "N/A")
        return recipe
    }

    private func getImage(fromFavoriteRecipe favoriteRecipe: FavoriteRecipe) -> UIImage {
        guard
            let imageData = favoriteRecipe.image,
            let image = UIImage(data: imageData)
            else { return UIImage.defaultRecipeImage }

        return image
    }

}
