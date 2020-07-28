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

    init(context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "Reciplease")
        //swiftlint:disable:next unused_closure_parameter
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        let context = container.viewContext
        return context
        }()
    ) {
        self.context = context
    }



    // MARK: Properties

    let context: NSManagedObjectContext



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
