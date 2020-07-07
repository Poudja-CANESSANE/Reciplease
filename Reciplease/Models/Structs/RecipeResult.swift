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
    let imageUrl, name, time, calories, url: String
    let ingredientLines: [String]
    let yield: Double
}

// MARK: - RecipeResult
struct RecipeResult: Codable {
    let q: String
    let from, to: Int
    let hits: [Hit]
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: Recipe
}

// MARK: - Recipe
struct Recipe: Codable {
    let label: String
    let image: String
    let url: String
    let yield: Double
    let ingredientLines: [String]
    let calories, totalTime: Double
}
