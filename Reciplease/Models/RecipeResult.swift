//swiftlint:disable identifier_name
//  RecipeResult.swift
//  Reciplease
//
//  Created by Canessane Poudja on 25/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let recipeResult = try? newJSONDecoder().decode(RecipeResult.self, from: jsonData)

import Foundation

struct RecipeObject {
    let bookmarked: Bool
    let imageUrl, name, time, calories: String
    let ingredientLines: [String]
}

// MARK: - RecipeResult
struct RecipeResult: Codable {
    let q: String
    let from, to: Int
    let more: Bool
    let count: Int
    let hits: [Hit]
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: Recipe
    let bookmarked, bought: Bool
}

// MARK: - Recipe
struct Recipe: Codable {
    let label: String
    let image: String
    let source: String
    let url: String
    let yield: Double
//    let dietLabels: [DietLabel]
//    let healthLabels: [HealthLabel]
//    let cautions: [Caution]
    let ingredientLines: [String]
    let ingredients: [Ingredient]
    let calories, totalWeight, totalTime: Double
}

//enum Caution: String, Codable {
//    case fodmap = "FODMAP"
//    case gluten = "Gluten"
//    case soy = "Soy"
//    case sulfites = "Sulfites"
//    case wheat = "Wheat"
//}

//enum DietLabel: String, Codable {
//    case balanced = "Balanced"
//    case highFiber = "High-Fiber"
//    case highProtein = "High-Protein"
//    case lowCarb = "Low-Carb"
//    case lowFat = "Low-Fat"
//    case lowSoduim = "Low-Sodium"
//}

//enum HealthLabel: String, Codable {
//    case alcoholFree = "Alcohol-Free"
//    case immunoSupportive = "Immuno-Supportive"
//    case celeryFree
//    case crustaceanFree
//    case dairyFree
//    case eggFree
//    case fishFree
//    case fodmapFree
//    case glutenFree
//    case ketoFriendly
//    case kidneyFriendly
//    case kosher
//    case lowPatassium
//    case lupineFree
//    case mustardFree
//    case lowFatAbs
//    case noOilAdded
//    case lowSugar
//    case paleo
//    case peanutFree = "Peanut-Free"
//    case pecatarian
//    case porkFree
//    case redMeatFree
//    case sesameFree
//    case shellfishFree
//    case soyFree
//    case sugarConscious = "Sugar-Conscious"
//    case treeNutFree = "Tree-Nut-Free"
//    case vegan
//    case vegetarian
//    case wheatFree
//
//    enum CodingKeys: String, CodingKey {
//        case hightFiber = "hight-fiber"
//        case hightProtein = "hight-protein"
//    }
//}

// MARK: - Ingredient
struct Ingredient: Codable {
    let text: String
    let weight: Double
}
