//
//  CoreDataManagerTests.swift
//  RecipleaseTests
//
//  Created by Canessane Poudja on 18/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import XCTest
import CoreData
@testable import Reciplease

class CoreDataManagerTests: XCTestCase {
    var coreDataManager: CoreDataManager!

    override func setUp() {
        super.setUp()
        assignNewValueToCoreDataManager()
    }
    override func tearDown() {
        super.tearDown()
        try! ContextProviderStub.persistentStoreDestroyer.destroyAllDataIfExist()
    }

    func testGetObject_SaveFood_AndGetAllElements() {
        savePotato()
        let foods = try! coreDataManager.getAllElements(ofType: Food.self)

        XCTAssertEqual(foods.count, 1)
        XCTAssertEqual(foods.first?.name, foodName)
    }

    func testRemoveAllElements() {
        savePotato()

        try! coreDataManager.removeElements(ofType: Food.self)

        let foods = try! coreDataManager.getAllElements(ofType: Food.self)
        XCTAssertTrue(foods.isEmpty)
    }

    func testGivenCoreDataManagerWithContextProviderStub_WhenSave_ThenShouldThrowError() {
        let coreDataManager = getCoreDataManagerWithContextProviderStub()

        XCTAssertThrowsError(try coreDataManager.save()) { error in
            XCTAssertEqual(error as! CoreDataError, CoreDataError.getErrorSavingContext)
        }
    }

    func testGivenCoreDataManagerWithContextProviderStub_WhenGetAllElements_ThenShouldThrowError() {
        let coreDataManager = getCoreDataManagerWithContextProviderStub()

        XCTAssertThrowsError(try coreDataManager.getAllElements(ofType: Food.self)) { error in
            XCTAssertEqual(error as! CoreDataError, CoreDataError.getErrorWhileFetchingFromCoreData)
        }
    }

    func testGivenCoreDataManagerWithContextProviderStub_WhenRemoveElements_ThenShouldThrowError() {
        let coreDataManager = getCoreDataManagerWithContextProviderStub()

        XCTAssertThrowsError(try coreDataManager.removeElements(ofType: Food.self)) { error in
            XCTAssertEqual(error as! CoreDataError, CoreDataError.getErrorWhileFetchingFromCoreData)
        }
    }

    func testGivenCoreDataManagerWithContextProviderSaveStub_WhenRemoveElements_ThenShouldThrowError() {
        let coreDataManager = getCoreDataManagerWithContextProviderSaveStub()

        XCTAssertThrowsError(try coreDataManager.removeElements(ofType: Food.self)) { error in
            XCTAssertEqual(error as! CoreDataError, CoreDataError.getErrorSavingContext)
        }
    }



    // MARK: Tools

    private let foodName = "Potato"

    private func assignNewValueToCoreDataManager() {
        let contextProvider = ContextProviderImplementation(
            context: ContextProviderStub.mockContext,
            persistentStoreDestroyer: ContextProviderStub.persistentStoreDestroyer)

        coreDataManager = CoreDataManager(contextProvider: contextProvider)
    }

    private func savePotato() {
        let food = coreDataManager.getObject(type: Food.self)
        food.name = foodName
        try! coreDataManager.save()
    }

    private func getCoreDataManagerWithContextProviderStub() -> CoreDataManager {
        let coreDataManager = CoreDataManager(contextProvider: ContextProviderStub())
        return coreDataManager
    }

    private func getCoreDataManagerWithContextProviderSaveStub() -> CoreDataManager {
        let coreDataManager = CoreDataManager(contextProvider: ContextProviderSaveStub())
        return coreDataManager
    }
}
