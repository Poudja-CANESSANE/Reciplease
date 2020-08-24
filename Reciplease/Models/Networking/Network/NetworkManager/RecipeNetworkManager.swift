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
    typealias RecipeFetchingResult = Result<RecipeResult, NetworkError>



    // MARK: Inits

    init(networkService: NetworkService = ServiceContainer.networkService,
         urlProvider: UrlProvider = ServiceContainer.urlProvider,
         dateFormatter: DateComponentsFormatter = DateComponentsFormatter(),
         numberFormatter: NumberFormatter = NumberFormatter()) {

        self.networkService = networkService
        self.urlProvider = urlProvider
        self.dateFormatter = dateFormatter
        self.numberFormatter = numberFormatter
    }



    // MARK: Methods

    ///Returns by the completion parameter the downloaded array of RecipeObject
    ///from the given food, minIndex and maxIndex
    func getRecipes(
        forFoods foods: String,
        fromMinIndex minIndex: Int,
        toMaxIndex maxIndex: Int,
        completion: @escaping RecipeCompletion) {

        guard let urlString = urlProvider.getUrlString(
            forFood: foods,
            fromMinIndex: minIndex,
            toMaxIndex: maxIndex) else { return completion(.failure(.cannotGetUrl)) }

        networkService.fetchDecodedData(urlString: urlString) { [weak self] (result: RecipeFetchingResult) in
            guard let self = self else { return }
            switch result {
            case .failure(let networkError):
                completion(.failure(networkError))
            case .success(let response):
                let recipes = self.getRecipeObjects(fromResponse: response)
                completion(.success(recipes))
            }
        }
    }

    ///Returns by the completion parameter the downloaded Data corresponding to the recipe's image from the given url
    func getRecipeImage(fromImageUrlString imageUrlString: String, completion: @escaping RecipeImageCompletion) {
        networkService.fetchData(urlString: imageUrlString) { result in
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
    private let dateFormatter: DateComponentsFormatter
    private let numberFormatter: NumberFormatter



    // MARK: Methods

    ///Returns an array of RecipeObject from the given RecipeResult
    private func getRecipeObjects(fromResponse response: RecipeResult) -> [RecipeObject] {
        var recipes = [RecipeObject]()

        response.hits.forEach {
            let recipe = createRecipeObject(fromHit: $0)
            recipes.append(recipe)
        }

        return recipes
    }

    ///Returns a RecipeObject build from the given Hit
    private func createRecipeObject(fromHit hit: Hit) -> RecipeObject {
        let imageUrl = hit.recipe.image
        let name = hit.recipe.label
        let ingredientLines = "- " + hit.recipe.ingredientLines.joined(separator: "\n" + "- ")
        let url = hit.recipe.url
        let yield = String(Int(hit.recipe.yield))

        let time = hit.recipe.totalTime
        let formattedtime = formatTime(minutes: time)

        let caloriesToFormat = Int(hit.recipe.calories)
        let formattedCalories = formatNumber(int: caloriesToFormat)

        let recipe = RecipeObject(
            imageUrl: imageUrl,
            name: name,
            time: formattedtime,
            calories: formattedCalories,
            url: url,
            ingredientLines: ingredientLines,
            yield: yield)

        return recipe
    }

    ///Returns the given Double corresponding to minutes formatted into days, hours and minutes for more readability
    private func formatTime(minutes: Double) -> String {
        if minutes == 0.0 { return "N/A" }
        dateFormatter.allowedUnits = [.day, .hour, .minute]
        dateFormatter.unitsStyle = .abbreviated
        dateFormatter.zeroFormattingBehavior = .dropAll

        let timeInSec = minutes * 60
        guard let formattedTime = dateFormatter.string(from: TimeInterval(timeInSec)) else { return "Error" }
        return formattedTime
    }

    ///Returns the given Int with spaces for more readability
    private func formatNumber(int: Int) -> String {
        numberFormatter.groupingSeparator = " "
        numberFormatter.numberStyle = .decimal

        guard let formattedNumber = numberFormatter.string(from: NSNumber(value: int)) else { return "NaN" }
        return formattedNumber
    }
}
