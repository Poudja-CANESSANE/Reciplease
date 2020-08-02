//
//  CoreDataError.swift
//  Reciplease
//
//  Created by Canessane Poudja on 27/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

enum CoreDataError: Error {
    case foodListDeletingIsImpossible
    case foodSavingIsImpossible
    case getErrorWhileFetchingFromCoreData
    case recipeWithImageSavingIsImpossible
    case favoriteRecipeDeletingIsImpossible
    case cannotUnwrapKey
    case getErrorSavingContext
    case cannotFindLastPersistentStoreUrl
    case cannotDestroyPersistantStore
    case cannotAddPersistantStore

    var message: String {
        switch self {
        case .foodListDeletingIsImpossible: return "The deleting of the food list is impossible"
        case .foodSavingIsImpossible: return "The saving of this food in Core Data is impossible !"
        case .getErrorWhileFetchingFromCoreData: return "An error occurred while fetching data from Core Data !"
        case .recipeWithImageSavingIsImpossible: return "The saving of this recipe is impossible !"
        case .favoriteRecipeDeletingIsImpossible: return "The deleting of this favorite recipe is impossible !"
        case .cannotUnwrapKey: return "Cannot unwrap key to save your settings !"
        case .getErrorSavingContext: return "An error occurred while saving the context !"
        case .cannotFindLastPersistentStoreUrl: return "Cannot unwrap the last persistant store URL !"
        case .cannotDestroyPersistantStore: return "Cannot destroy the persistant store !"
        case .cannotAddPersistantStore: return "Cannot add a new persistant store !"
        }
    }
}
