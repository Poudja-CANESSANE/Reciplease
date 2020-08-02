//
//  ContextProviderSaveStub.swift
//  RecipleaseTests
//
//  Created by Canessane Poudja on 27/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

@testable import Reciplease
import CoreData

class ContextProviderSaveStub: ContextProvider {
    var persistentStoreDestroyer: PersistentStoreDestroyer = PersistentStoreDestroyer(
        context: ContextProviderStub.mockContext,
        persistentStoreCoordinator: ContextProviderStub.mockContext.persistentStoreCoordinator,
        storeURL: ContextProviderStub.mockContext.persistentStoreCoordinator?.persistentStores.last?.url)

    // MARK: - INTERNAL

    // MARK: Properties

    let context = ContextProviderStub.mockContext



    // MARK: Methods

    func fetch<T: NSFetchRequestResult>(_ request: NSFetchRequest<T>) throws -> [T] {
        try context.fetch(request)
    }

    func save() throws {
        throw CoreDataError.getErrorSavingContext
    }

    func delete(_ object: NSManagedObject) {
        context.delete(object)
    }
}
