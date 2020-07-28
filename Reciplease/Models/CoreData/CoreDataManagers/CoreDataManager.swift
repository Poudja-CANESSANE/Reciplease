//
//  CoreDataManager.swift
//  Reciplease
//
//  Created by Canessane Poudja on 13/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import CoreData

class CoreDataManager {
    // MARK: - INTERNAL

    // MARK: Inits

    init(contextProvider: ContextProvider = ServiceContainer.contextProvider) {
        self.contextProvider = contextProvider
    }



    // MARK: Properties

    let contextProvider: ContextProvider



    // MARK: Methods

    ///Returns all entities of the given type from Core Data
    func getAllElements<T: NSManagedObject>(ofType genericType: T.Type) throws -> [T] {
        let request = NSFetchRequest<T>(entityName: "\(T.self)")
        request.returnsObjectsAsFaults = false
        var elements: [T]
        do { elements = try contextProvider.fetch(request)
        } catch { throw CoreDataError.getErrorWhileFetchingFromCoreData }
        return elements
    }

    ///Removes all entities of the given type from Core Data
    func removeElements<T: NSManagedObject>(ofType type: T.Type) throws {
        var elements: [T]
        do { elements = try getAllElements(ofType: type) } catch { throw error }
        elements.forEach { contextProvider.delete($0) }
        do { try save() } catch { throw error }
    }

    ///Saves all uncommited changes in the context
    func save() throws {
        do { try contextProvider.save() } catch { throw CoreDataError.getErrorSavingContext }
    }

    ///Returns an NSManagedObject from the given type
    func getObject<T: NSManagedObject>(type: T.Type) -> T {
        //swiftlint:disable:next force_cast
        NSEntityDescription.insertNewObject(forEntityName: "\(T.self)", into: contextProvider.context) as! T
    }
}
