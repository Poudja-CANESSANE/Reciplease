//
//  PersistentStoreDestroyer.swift
//  Reciplease
//
//  Created by Canessane Poudja on 30/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import CoreData

class PersistentStoreDestroyer {
    // MARK: - INTERNAL

    // MARK: Inits

    init(context: NSManagedObjectContext,
         persistentStoreCoordinator: NSPersistentStoreCoordinator?,
         storeURL: URL?) {
        self.context = context
        self.persistentStoreCoordinator = persistentStoreCoordinator
        self.storeURL = storeURL
    }



    // MARK: Methods

    ///Destroys the current persistentStore and add a new one
    func destroyAllDataIfExist() throws {
        let storeType = NSSQLiteStoreType
        guard
            let persistentStoreCoordinator = persistentStoreCoordinator,
            let storeURL = storeURL else {

                throw CoreDataError.cannotFindLastPersistentStoreUrl
        }

        do {
            try persistentStoreCoordinator.destroyPersistentStore(at: storeURL, ofType: storeType)
        } catch { throw CoreDataError.cannotDestroyPersistantStore }

        do {
            try persistentStoreCoordinator.addPersistentStore(
                ofType: storeType,
                configurationName: nil,
                at: storeURL)
        } catch { throw CoreDataError.cannotAddPersistantStore }
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private let context: NSManagedObjectContext
    private let persistentStoreCoordinator: NSPersistentStoreCoordinator?
    private let storeURL: URL?
}
