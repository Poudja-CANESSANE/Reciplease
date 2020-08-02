//
//  PersistentStoreCoordinatorAddStub.swift
//  RecipleaseTests
//
//  Created by Canessane Poudja on 31/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import CoreData
@testable import Reciplease

class PersistentStoreCoordinatorAddStub: NSPersistentStoreCoordinator {
    override func destroyPersistentStore(at url: URL, ofType storeType: String, options: [AnyHashable : Any]? = nil) throws {
        try super.destroyPersistentStore(at: url, ofType: storeType, options: options)
    }
    override func addPersistentStore(ofType storeType: String, configurationName configuration: String?, at storeURL: URL?, options: [AnyHashable : Any]? = nil) throws -> NSPersistentStore {
        throw CoreDataError.cannotAddPersistantStore
    }
}
