//
//  ContextProvider.swift
//  Reciplease
//
//  Created by Canessane Poudja on 27/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import CoreData

protocol ContextProvider {
    var context: NSManagedObjectContext { get }
    var persistentStoreDestroyer: PersistentStoreDestroyer { get }

    func fetch<T: NSFetchRequestResult>(_ request: NSFetchRequest<T>) throws -> [T]
    func save() throws
    func delete(_ object: NSManagedObject)
}
