//
//  FoodDataManager.swift
//  Reciplease
//
//  Created by Canessane Poudja on 14/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class FoodDataManager {
    // MARK: - INTERNAL

    // MARK: Methods

    ///Returns an array containing all Food object saved in Core Data
    func getAll() -> [Food] {
        coreDataManager.getAllElements(ofType: Food.self)
    }

    ///Removes all Food entities from Core Data
    func removeAll() throws {
        do { try coreDataManager.removeElements(ofType: Food.self) } catch { throw error }
    }

    ///Creates and saves a Food with the given name in Core Data
    func save(name: String) throws {
        do {
            let food = coreDataManager.getObject(type: Food.self)
            food.name = name
            try coreDataManager.save()
        } catch { throw error }
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private let coreDataManager = ServiceContainer.coreDataManager
}
