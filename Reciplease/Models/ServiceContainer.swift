//
//  ServiceContainer.swift
//  Reciplease
//
//  Created by Canessane Poudja on 12/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import CoreData

struct ServiceContainer {
    static let settingsService = SettingsService()
    static let alertManager = AlertManager()
    static let networkService = NetworkServiceImplementation()
    static let urlProvider = UrlProviderImplementation()
    static let recipeNetworkManager = RecipeNetworkManager()
    static let coreDataManager = CoreDataManager()
    static let foodDataManager = FoodDataManager()
    static let favoriteRecipeDataManager = FavoriteRecipeDataManager()
    static let urlValueProvider = UrlValueProvider()
    static let urlComponent = URLComponentImplementation()
    static let alamofireNetworkRequest = AlamofireNetworkRequest()
    static let contextProvider = ContextProviderImplementation()

    ///Returns a NSManagedObjectContext from the given NSPersistentContainer
    static func getContext(fromContainer container: NSPersistentContainer =
        NSPersistentContainer(name: "Reciplease")) -> NSManagedObjectContext {

        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        let context = container.viewContext
        return context
    }
}
