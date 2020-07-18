//
//  CustomError.swift
//  Reciplease
//
//  Created by Canessane Poudja on 27/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

enum CustomError: Error {
    case cannotGetUrl
    case noData
    case cannotDecodeData
    case cannotUnwrapFirstHit
    case cannotGetImageUrlFromRecipe
    case cannotUnwrapKey
    case foodListDeletingIsImpossible
    case foodSavingIsImpossible
    case getErrorWhileFetchingFromCoreData
    case cannotUnwrapUrl
    case recipeWithImageSavingIsImpossible
    case favoriteRecipeDeletingIsImpossible

    var message: String {
        switch self {
        case .cannotGetUrl: return "The URL is wrong !"
        case .cannotDecodeData: return "The data decoding is impossible !"
        case .noData: return "There is no data !\nCheck your internet connection or change your settings."
        case .cannotUnwrapFirstHit: return "The unwrapping of the first Hit is impossible !"
        case .cannotGetImageUrlFromRecipe: return "Cannot get the image URL from the RecipeObject !"
        case .cannotUnwrapKey: return "Cannot unwrap key to save your settings !"
        case .foodListDeletingIsImpossible: return "The deleting of the food list is impossible"
        case .foodSavingIsImpossible: return "The saving of this food in Core Data is impossible !"
        case .getErrorWhileFetchingFromCoreData: return "An error occurred while fetching data from Core Data !"
        case .cannotUnwrapUrl: return "Cannot unwrap URL !"
        case .recipeWithImageSavingIsImpossible: return "The saving of this recipe is impossible !"
        case .favoriteRecipeDeletingIsImpossible: return "The deleting of this favorite recipe is impossible !"
        }
    }
}
