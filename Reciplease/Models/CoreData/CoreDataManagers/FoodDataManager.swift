//swiftlint:disable statement_position
//  FoodDataManager.swift
//  Reciplease
//
//  Created by Canessane Poudja on 14/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class FoodDataManager {
    // MARK: - INTERNAL

    // MARK: Inits

    init(coreDataManager: CoreDataManager = ServiceContainer.coreDataManager) {
        self.coreDataManager = coreDataManager
    }

    // MARK: Methods

    ///Returns an array containing all Food object saved in Core Data
    func getAll() throws -> [Food] {
        var foods: [Food]
        do { foods = try coreDataManager.getAllElements(ofType: Food.self) }
        catch { throw error }
        return foods
    }

    ///Removes all Food entities from Core Data
    func removeAll() throws {
        do { try coreDataManager.removeElements(ofType: Food.self) } catch { throw error }
    }

    ///Creates and saves a Food with the given name in Core Data
    func save(name: String) throws {
        let food = coreDataManager.getObject(type: Food.self)
        food.name = name
        do { try coreDataManager.save() } catch { throw error }
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private let coreDataManager: CoreDataManager
}
