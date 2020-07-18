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

    func getAll() -> [FavoriteRecipe] {
        coreDataManager.getAllElements(ofType: FavoriteRecipe.self)
    }

    func deleteFavoriteRecipe(withUrl url: String) throws {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", url)
        guard let favoriteRecipesToRemove = try? coreDataManager.context.fetch(request) else { return }
        favoriteRecipesToRemove.forEach { coreDataManager.context.delete($0)}

        do { try coreDataManager.save() } catch { throw error }
    }

    func isFavorite(recipeUrl url: String) throws -> Bool {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", url)

        do {
            let count = try coreDataManager.context.fetch(request)
            return count.isEmpty ? false : true
        } catch { throw error }
    }

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
