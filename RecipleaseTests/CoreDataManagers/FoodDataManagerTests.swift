//
//  FoodDataManagerTests.swift
//  RecipleaseTests
//
//  Created by Canessane Poudja on 18/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import XCTest
@testable import Reciplease

class FoodDataManagerTests: XCTestCase {
    let foodDataManager = FoodDataManager()

    override func setUp() {
        super.setUp()
        try! foodDataManager.removeAll()
    }

    func testSaveFoodAndGetAllFood() {
        try! foodDataManager.save(name: "Potatoe")
        let foods = foodDataManager.getAll()

        XCTAssertEqual(foods.count, 1)
        XCTAssertEqual(foods.first?.name, "Potatoe")
    }

    func testRemoveAllFood() {
        try! foodDataManager.save(name: "Potatoe")
        try! foodDataManager.removeAll()
        let foods = foodDataManager.getAll()

        XCTAssertTrue(foods.isEmpty)
    }
}
