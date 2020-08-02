//
//  PersistentStoreDestroyerTests.swift
//  RecipleaseTests
//
//  Created by Canessane Poudja on 31/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import XCTest
import CoreData
@testable import Reciplease

class PersistentStoreDestroyerTests: XCTestCase {
    var persistentStoreDestroyer: PersistentStoreDestroyer!

    override func tearDown() {
        super.tearDown()
        persistentStoreDestroyer = nil
    }

    func testGivenPersistentStoreDestroyerWithNoPersistentStoreCoordinator_WhenDestroyAllDataIfExist_ThenThrowError() {
        persistentStoreDestroyer = PersistentStoreDestroyer(
            context: ContextProviderStub.mockContext,
            persistentStoreCoordinator: nil,
            storeURL: url)

        XCTAssertThrowsError(try persistentStoreDestroyer.destroyAllDataIfExist()) { error in
            XCTAssertEqual(error as! CoreDataError, CoreDataError.cannotFindLastPersistentStoreUrl)
        }
    }

    func testGivenPersistentStoreDestroyerWithPersistentStoreCoordinatorDestroyStub_WhenDestroyAllDataIfExist_ThenThrowError() {
        persistentStoreDestroyer = PersistentStoreDestroyer(
            context: ContextProviderStub.mockContext,
            persistentStoreCoordinator: PersistentStoreCoordinatorDestroyStub(),
            storeURL: url)

        XCTAssertThrowsError(try persistentStoreDestroyer.destroyAllDataIfExist()) { error in
            XCTAssertEqual(error as! CoreDataError, CoreDataError.cannotDestroyPersistantStore)
        }
    }

    func testGivenPersistentStoreDestroyerWithPersistentStoreCoordinatorAddStub_WhenDestroyAllDataIfExist_ThenThrowError() {
        persistentStoreDestroyer = PersistentStoreDestroyer(
            context: ContextProviderStub.mockContext,
            persistentStoreCoordinator: PersistentStoreCoordinatorAddStub(),
            storeURL: url)

        XCTAssertThrowsError(try persistentStoreDestroyer.destroyAllDataIfExist()) { error in
            XCTAssertEqual(error as! CoreDataError, CoreDataError.cannotAddPersistantStore)
        }
    }



    // MARK: Tools

    private let url = URL(string: "file:///dev/null")
}
