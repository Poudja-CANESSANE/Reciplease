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

    // MARK: Properties

    lazy var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "Reciplease")
        //swiftlint:disable:next unused_closure_parameter
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? { fatalError("Unresolved error \(error), \(error.userInfo)") }
        }

        let context = container.viewContext
        return context
    }()



    // MARK: Methods

    ///Returns all entities of the given type from Core Data
    func getAllElements<T: NSManagedObject>(ofType genericType: T.Type) -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
          request.returnsObjectsAsFaults = false
          guard let elements = try? context.fetch(request) else { return [] }
          return elements
    }

    ///Removes all entities of the given type from Core Data
    func removeElements<T: NSManagedObject>(ofType type: T.Type) throws {
        let elements = getAllElements(ofType: type)
        elements.forEach { context.delete($0) }
        do { try context.save() } catch { throw error }
    }

    ///Saves all uncommited changes in the context
    func save() throws {
        do { try context.save() } catch { throw error }
    }

    ///Returns an NSManagedObject from the given type
    func getObject<T: NSManagedObject>(type: T.Type) -> T {
        //swiftlint:disable:next force_cast
        NSEntityDescription.insertNewObject(forEntityName: String(describing: T.self), into: context) as! T
    }
}
