//
//  FavoriteRecipeDataManager.swift
//  Reciplease
//
//  Created by Canessane Poudja on 14/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import CoreData

class FavoriteRecipeDataManager {
    // MARK: - INTERNAL

    // MARK: Methods

    ///Returns an array containing all FavoriteRecipe object saved in Core Data
    func getAll() -> [FavoriteRecipe] {
        coreDataManager.getAllElements(ofType: FavoriteRecipe.self)
    }

    ///Removes a specific FavoriteRecipe with the given url from Core Data
    func deleteFavoriteRecipe(withUrl url: String) throws {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", url)
        guard let favoriteRecipesToRemove = try? coreDataManager.context.fetch(request) else { return }
        favoriteRecipesToRemove.forEach { coreDataManager.context.delete($0)}

        do { try coreDataManager.save() } catch { throw error }
    }

    ///Returns a Bool whether the Recipe is favorite according to its presence or not in Core Data
    func isFavorite(recipeUrl url: String) throws -> Bool {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", url)

        do {
            let count = try coreDataManager.context.fetch(request)
            return count.isEmpty ? false : true
        } catch { throw error }
    }

    ///Creates and saves a FavoriteRecipe entity from a RecipeWithImage object in Core Data
    func save(_ recipeWithImage: RecipeWithImage) throws {
        do {
            let favoriteRecipe = coreDataManager.getObject(type: FavoriteRecipe.self)

            favoriteRecipe.name = recipeWithImage.recipe.name
            favoriteRecipe.calories = recipeWithImage.recipe.calories
            favoriteRecipe.ingredientLines = recipeWithImage.recipe.ingredientLines
            favoriteRecipe.time = recipeWithImage.recipe.time
            favoriteRecipe.url = recipeWithImage.recipe.url
            favoriteRecipe.yield = recipeWithImage.recipe.yield
            favoriteRecipe.image = recipeWithImage.image.pngData()

            try coreDataManager.save()
        } catch { throw error }
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private let coreDataManager = ServiceContainer.coreDataManager
}
