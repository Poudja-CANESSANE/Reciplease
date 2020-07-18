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

    func getAll() -> [Food] {
        coreDataManager.getAllElements(ofType: Food.self)
    }

    func removeAll() throws {
        do { try coreDataManager.removeElements(ofType: Food.self) } catch { throw error }
    }

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
