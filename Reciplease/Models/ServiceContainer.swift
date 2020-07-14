//
//  ServiceContainer.swift
//  Reciplease
//
//  Created by Canessane Poudja on 12/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class ServiceContainer {
    static let settingsService = SettingsService()
    static let alertManager = AlertManager()

    static let recipeNetworkManager = RecipeNetworkManager(
        networkService: NetworkServiceImplementation(),
        urlProvider: UrlProviderImplementation())

    static let coreDataManager = CoreDataManager()
    static let foodDataManager = FoodDataManager()
    static let favoriteRecipeDataManager = FavoriteRecipeDataManager()
}
