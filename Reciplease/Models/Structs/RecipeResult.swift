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

struct RecipeResult: Codable, Equatable {
    static func == (lhs: RecipeResult, rhs: RecipeResult) -> Bool {
        return (lhs.q == rhs.q &&
            lhs.from == lhs.from &&
            lhs.to == rhs.to &&
            lhs.hits == rhs.hits)
    }

    let q: String
    let from, to: Int
    let hits: [Hit]
}

struct Hit: Codable, Equatable {
    static func == (lhs: Hit, rhs: Hit) -> Bool {
        return lhs.recipe == rhs.recipe
    }

    let recipe: Recipe
}

struct Recipe: Codable, Equatable {
    let label: String
    let image: String
    let url: String
    let yield: Double
    let ingredientLines: [String]
    let calories, totalTime: Double
}
