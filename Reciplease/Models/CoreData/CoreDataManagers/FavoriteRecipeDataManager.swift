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

    // MARK: Inits

    init(coreDataManager: CoreDataManager = ServiceContainer.coreDataManager) {
        self.coreDataManager = coreDataManager
    }



    // MARK: Properties

    let coreDataManager: CoreDataManager



    // MARK: Methods

    ///Returns an array containing all FavoriteRecipe object saved in Core Data
    func getAll() throws -> [FavoriteRecipe] {
        var favoriteRecipes: [FavoriteRecipe]
        do { favoriteRecipes = try coreDataManager.getAllElements(ofType: FavoriteRecipe.self) } catch { throw error }
        return favoriteRecipes
    }

    ///Removes a specific FavoriteRecipe with the given url from Core Data
    func deleteFavoriteRecipe(withUrl url: String) throws {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", url)
        var favoriteRecipesToRemove: [FavoriteRecipe]
        do { favoriteRecipesToRemove = try coreDataManager.contextProvider.fetch(request) } catch { throw error }
        favoriteRecipesToRemove.forEach { coreDataManager.contextProvider.delete($0) }
        do { try coreDataManager.save() } catch { throw error }
    }

    ///Returns a Bool whether the Recipe is favorite according to its presence or not in Core Data
    func isFavorite(recipeUrl url: String) throws -> Bool {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", url)
        request.returnsObjectsAsFaults = false
        var favoriteRecipes = [FavoriteRecipe]()
        do { favoriteRecipes = try coreDataManager.contextProvider.fetch(request)
        } catch { throw error }
        return favoriteRecipes.isEmpty ? false : true
    }

    ///Creates and saves a FavoriteRecipe entity from a RecipeWithImage object in Core Data
    func save(_ recipeWithImage: RecipeWithImage) throws {
        let favoriteRecipe = coreDataManager.getObject(type: FavoriteRecipe.self)

        favoriteRecipe.name = recipeWithImage.recipe.name
        favoriteRecipe.calories = recipeWithImage.recipe.calories
        favoriteRecipe.ingredientLines = recipeWithImage.recipe.ingredientLines
        favoriteRecipe.time = recipeWithImage.recipe.time
        favoriteRecipe.url = recipeWithImage.recipe.url
        favoriteRecipe.yield = recipeWithImage.recipe.yield
        favoriteRecipe.image = recipeWithImage.image.pngData()

        do { try coreDataManager.save() } catch { throw error }
    }
}
