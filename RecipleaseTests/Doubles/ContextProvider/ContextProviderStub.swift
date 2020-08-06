//
//  ContextProviderStub.swift
//  RecipleaseTests
//
//  Created by Canessane Poudja on 27/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

@testable import Reciplease
import CoreData

class ContextProviderStub: ContextProvider {
    static let persistentStoreDestroyer = PersistentStoreDestroyer(
    context: mockContext,
    persistentStoreCoordinator: mockContext.persistentStoreCoordinator,
    storeURL: mockContext.persistentStoreCoordinator?.persistentStores.last?.url)

    //MARK: mock in-memory persistant store
    static let mockContext = mockPersistantContainer.viewContext



    // MARK: - INTERNAL

    // MARK: Properties

    let context = mockContext


    // MARK: Methods

    func fetch<T: NSFetchRequestResult>(_ request: NSFetchRequest<T>) throws -> [T] {
        throw CoreDataError.getErrorWhileFetchingFromCoreData
    }

    func save() throws {
        throw CoreDataError.getErrorSavingContext
    }

    func delete(_ object: NSManagedObject) {
        return
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private static let mockPersistantContainer: NSPersistentContainer = {

         let container = NSPersistentContainer(name: "Reciplease")
         let description = NSPersistentStoreDescription()
         description.type = NSInMemoryStoreType
         description.shouldAddStoreAsynchronously = false // Make it simpler in test env

         container.persistentStoreDescriptions = [description]
         container.loadPersistentStores { (description, error) in
             // Check if the data store is in memory
             precondition( description.type == NSInMemoryStoreType )

             // Check if creating container wrong
             if let error = error {
                Swift.fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
}
