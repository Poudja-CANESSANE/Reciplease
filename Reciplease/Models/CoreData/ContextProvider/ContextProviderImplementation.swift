//
//  ContextProviderImplementation.swift
//  Reciplease
//
//  Created by Canessane Poudja on 27/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import CoreData

class ContextProviderImplementation: ContextProvider {
    // MARK: - INTERNAL

    // MARK: Inits

    init(context: NSManagedObjectContext = ServiceContainer.getContext(),
         persistentStoreDestroyer: PersistentStoreDestroyer =
        PersistentStoreDestroyer(
            context: ServiceContainer.getContext(),
            persistentStoreCoordinator: ServiceContainer.getContext().persistentStoreCoordinator,
            storeURL: ServiceContainer.getContext().persistentStoreCoordinator?.persistentStores.last?.url)) {

        self.context = context
        self.persistentStoreDestroyer = persistentStoreDestroyer
    }

    


    // MARK: Properties

    let context: NSManagedObjectContext
    let persistentStoreDestroyer: PersistentStoreDestroyer



    // MARK: Methods

    ///Returns an array of the given generic type by trying the NSManagedObjectContext's fetch() method
    func fetch<T: NSFetchRequestResult>(_ request: NSFetchRequest<T>) throws -> [T] {
        try context.fetch(request)
    }

    ///Tries the NSManagedObjectContext's save() method
    func save() throws {
        try context.save()
    }

    ///Call the NSManagedObjectContext's delete() method
    func delete(_ object: NSManagedObject) {
        context.delete(object)
    }
}
