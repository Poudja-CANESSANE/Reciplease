//
//  Ingredient.swift
//  Reciplease
//
//  Created by Canessane Poudja on 25/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import CoreData

class Food: NSManagedObject {
    static var all: [Food] {
        let request: NSFetchRequest<Food> = Food.fetchRequest()
        request.returnsObjectsAsFaults = false
        guard let foods = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return foods
    }

    static func removeFoods() {
        all.forEach { AppDelegate.viewContext.delete($0) }

        do {
            try AppDelegate.viewContext.save()
            print(all)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    static func saveFood(named name: String) {
        let food = Food(context: AppDelegate.viewContext)
        food.name = name

        do {
            try AppDelegate.viewContext.save()
            print("\(food.name ?? "food.name") successfully saved")
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
