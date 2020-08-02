//
//  FoodDataManagerTests.swift
//  RecipleaseTests
//
//  Created by Canessane Poudja on 18/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import XCTest
import CoreData
@testable import Reciplease

class FoodDataManagerTests: XCTestCase {
    var foodDataManager: FoodDataManager!

    override func setUp() {
        super.setUp()
        assignNewValueToFoodDataManager()
    }

    override func tearDown() {
        super.tearDown()
        try! foodDataManager.coreDataManager.contextProvider.persistentStoreDestroyer.destroyAllDataIfExist()
    }

    func testSaveFood_AndGetAllFood() {
        try! foodDataManager.save(name: foodName)
        let foods = try! foodDataManager.getAll()

        XCTAssertEqual(foods.count, 1)
        XCTAssertEqual(foods.first?.name, foodName)
    }

    func testRemoveAllFood() {
        try! foodDataManager.save(name: foodName)
        try! foodDataManager.removeAll()
        let foods = try! foodDataManager.getAll()

        XCTAssertTrue(foods.isEmpty)
    }

    func testGivenFoodDataManagerWithCoreDataManagerStub_WhenSave_ThenShouldThrowError() {
        let foodDataManagerStub = getFoodDataManagerWithContextProviderStub()

        XCTAssertThrowsError(try foodDataManagerStub.save(name: foodName)) { error in
            XCTAssertEqual(error as! CoreDataError, CoreDataError.getErrorSavingContext)
        }
    }

    func testGivenFoodDataManagerWithCoreDataManagerStub_WhenGetAll_ThenShouldThrowError() {
        let foodDataManagerStub = getFoodDataManagerWithContextProviderStub()

        XCTAssertThrowsError(try foodDataManagerStub.getAll()) { error in
            XCTAssertEqual(error as! CoreDataError, CoreDataError.getErrorWhileFetchingFromCoreData)
        }
    }

    func testGivenFoodDataManagerWithCoreDataManagerSaveStub_WhenRemoveAll_ThenShouldThrowError() {
        let foodDataManagerStub = getFoodDataManagerWithContextProviderStub()

        XCTAssertThrowsError(try foodDataManagerStub.removeAll()) { error in
            XCTAssertEqual(error as! CoreDataError, CoreDataError.getErrorWhileFetchingFromCoreData)
        }
    }



    // MARK: Tools

    private let foodName = "Potato"

    private func assignNewValueToFoodDataManager() {
        let contextProvider = ContextProviderImplementation(
            context: ContextProviderStub.mockContext,
            persistentStoreDestroyer: PersistentStoreDestroyer(
                context: ContextProviderStub.mockContext,
                persistentStoreCoordinator: ContextProviderStub.mockContext.persistentStoreCoordinator,
                storeURL: ContextProviderStub.mockContext.persistentStoreCoordinator?.persistentStores.last?.url))

        let mockCoreDataManager = CoreDataManager(contextProvider: contextProvider)
        foodDataManager = FoodDataManager(coreDataManager: mockCoreDataManager)
    }

    private func getFoodDataManagerWithContextProviderStub() -> FoodDataManager {
        let coreDataManager = CoreDataManager(contextProvider: ContextProviderStub())
        let foodDataManager = FoodDataManager(coreDataManager: coreDataManager)
        return foodDataManager
    }
}
