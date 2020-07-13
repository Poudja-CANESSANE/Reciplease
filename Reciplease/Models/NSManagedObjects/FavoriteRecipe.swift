//
//  FavoriteRecipe.swift
//  Reciplease
//
//  Created by Canessane Poudja on 11/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import CoreData

class FavoriteRecipe: NSManagedObject {
    static var all: [FavoriteRecipe] {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        request.returnsObjectsAsFaults = false
        guard let favoriteRecipes = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return favoriteRecipes
    }

    static func deleteFavoriteRecipe(withUrl url: String) {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", url)
        guard let favoriteRecipesToRemove = try? AppDelegate.viewContext.fetch(request) else { return }
        favoriteRecipesToRemove.forEach { AppDelegate.viewContext.delete($0)}

        do {
            try AppDelegate.viewContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    static func save(recipe: FavoriteRecipe) {
        do {
            try AppDelegate.viewContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    static func isFavorite(recipeUrl url: String) -> Bool {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", url)

        do {
            let count = try AppDelegate.viewContext.fetch(request)
            return count.isEmpty ? false : true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
