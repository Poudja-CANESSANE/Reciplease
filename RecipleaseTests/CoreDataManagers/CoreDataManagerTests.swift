//
//  CoreDataManagerTests.swift
//  RecipleaseTests
//
//  Created by Canessane Poudja on 18/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import XCTest
@testable import Reciplease

class CoreDataManagerTests: XCTestCase {
    let coreDataManager = CoreDataManager()

    override func setUp() {
        super.setUp()
        try! coreDataManager.removeElements(ofType: Food.self)
    }

    func testGetObjectOfTypeFood() {
        let food = coreDataManager.getObject(type: Food.self)
        XCTAssertTrue((food as Any) is Food)
    }

    func testSaveFood() {
        let food = coreDataManager.getObject(type: Food.self)
        food.name = "Potatoe"
        try! coreDataManager.save()
        let foods = coreDataManager.getAllElements(ofType: Food.self)

        XCTAssertTrue((food as Any) is Food)
        XCTAssertEqual(foods.count, 1)
        XCTAssertEqual(foods.first?.name, "Potatoe")
    }

    func testRemoveAllFood() {
        savePotatoe()

        try! coreDataManager.removeElements(ofType: Food.self)

        let foods = coreDataManager.getAllElements(ofType: Food.self)
        XCTAssertTrue(foods.isEmpty)
    }



    // MARK: Tools

    private func savePotatoe() {
        let food = coreDataManager.getObject(type: Food.self)
        food.name = "Potatoe"
        try! coreDataManager.save()
    }
}
