//
//  RecipeNetworkManager.swift
//  Reciplease
//
//  Created by Canessane Poudja on 27/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class RecipeNetworkManager {
    // MARK: - INTERNAL

    typealias RecipeCompletion = (Result<[RecipeObject], NetworkError>) -> Void
    typealias RecipeImageCompletion = (Result<Data, NetworkError>) -> Void



    // MARK: Inits

    init(networkService: NetworkService,
         urlProvider: UrlProvider) {
        self.networkService = networkService
        self.urlProvider = urlProvider
    }



    // MARK: Methods

    ///Returns by the completion parameter the downloaded us rate
    func getRecipes(
        forFoods foods: String,
        fromMinIndex minIndex: Int,
        toMaxIndex maxIndex: Int,
        completion: @escaping RecipeCompletion) {

        guard let url = urlProvider.getUrl(forFood: foods, fromMinIndex: minIndex, toMaxIndex: maxIndex) else {
            completion(.failure(.cannotGetUrl))
            return
        }

        networkService.fetchData(url: url) { [weak self] (result: Result<RecipeResult, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .failure(let networkError):
                completion(.failure(networkError))
            case .success(let response):
                let recipes = self.getRecipes(fromResponse: response)
                completion(.success(recipes))
            }
        }
    }

    func getRecipeImage(fromImageString imageString: String, completion: @escaping RecipeImageCompletion) {
        guard let url = URL(string: imageString) else {
            return completion(.failure(.cannotGetImageUrlFromRecipe))
        }

        networkService.fetchData(url: url) { (result: Result<Data, NetworkError>) in
            switch result {
            case .failure(let networkError):
                completion(.failure(networkError))
            case .success(let imageData):
                completion(.success(imageData))
            }
        }
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private let networkService: NetworkService
    private let urlProvider: UrlProvider



    // MARK: Methods

    private func getRecipes(fromResponse response: RecipeResult) -> [RecipeObject] {
        var recipes = [RecipeObject]()

        response.hits.forEach {
            let recipe = createRecipeObject(fromHit: $0)
            recipes.append(recipe)
        }

        return recipes
    }

    private func createRecipeObject(fromHit hit: Hit) -> RecipeObject {
        let bookmarked = hit.bookmarked
        let imageUrl = hit.recipe.image
        let name = hit.recipe.label
        let ingredientLines = hit.recipe.ingredientLines

        let time = hit.recipe.totalTime
        let formattedtime = formatTime(minutes: time)

        let caloriesToFormat = Int(hit.recipe.calories)
        let formattedCalories = formatNumber(int: caloriesToFormat)

        let recipe = RecipeObject(
            bookmarked: bookmarked,
            imageUrl: imageUrl,
            name: name,
            time: formattedtime,
            calories: formattedCalories,
            ingredientLines: ingredientLines)

        return recipe
    }

    private func formatTime(minutes: Double) -> String {
        if minutes == 0.0 { return "N/A" }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropAll

        let timeInSec = minutes * 60
        guard let formattedTime = formatter.string(from: TimeInterval(timeInSec)) else {
            return "Error"
        }

        return formattedTime
    }

    private func formatNumber(int: Int) -> String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal

        guard let formattedNumber = formatter.string(from: NSNumber(value: int)) else {
            return "NaN"
        }

        return formattedNumber
    }
}
