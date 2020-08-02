//
//  ContextProviderTests.swift
//  RecipleaseTests
//
//  Created by Canessane Poudja on 30/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import XCTest
import CoreData
@testable import Reciplease

class ContextProviderTests: XCTestCase {
    var contextProvider: ContextProviderImplementation!

    override func setUp() {
        super.setUp()
        assignNewValueToContextProvider()
    }
    override func tearDown() {
        super.tearDown()
        try! contextProvider.persistentStoreDestroyer.destroyAllDataIfExist()
    }

    func testFetch() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")
        let foods = try! contextProvider.fetch(request)

        XCTAssertTrue(foods.isEmpty)
    }

    func testSave() {
        let food = NSEntityDescription.insertNewObject(forEntityName: "Food", into: contextProvider.context) as! Food
        food.name = foodName

        try! contextProvider.save()

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let foods = try! contextProvider.fetch(request) as! [Food]

        XCTAssertEqual(foods.count, 1)
        XCTAssertEqual(foods.first?.name, foodName)
    }

    func testDelete() {
        let food = NSEntityDescription.insertNewObject(forEntityName: entityName, into: contextProvider.context) as! Food
        food.name = foodName

        try! contextProvider.save()
        contextProvider.delete(food)

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let foods = try! contextProvider.fetch(request) as! [Food]

        XCTAssertTrue(foods.isEmpty)
    }



    // MARK: Tools

    private let foodName = "Potato"
    private let entityName = "Food"

    private func assignNewValueToContextProvider() {
        let contextProvider = ContextProviderImplementation(
            context: ContextProviderStub.mockContext,
            persistentStoreDestroyer: PersistentStoreDestroyer(
                context: ContextProviderStub.mockContext,
                persistentStoreCoordinator: ContextProviderStub.mockContext.persistentStoreCoordinator,
                storeURL: ContextProviderStub.mockContext.persistentStoreCoordinator?.persistentStores.last?.url))
        self.contextProvider = contextProvider
    }
}
