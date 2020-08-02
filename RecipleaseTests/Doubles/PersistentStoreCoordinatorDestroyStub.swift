//
//  PersistentStoreCoordinatorDestroyStub.swift
//  RecipleaseTests
//
//  Created by Canessane Poudja on 31/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import CoreData
@testable import Reciplease

class PersistentStoreCoordinatorDestroyStub: NSPersistentStoreCoordinator {
    override func destroyPersistentStore(at url: URL, ofType storeType: String, options: [AnyHashable : Any]? = nil) throws {
        throw CoreDataError.cannotDestroyPersistantStore
    }
}
