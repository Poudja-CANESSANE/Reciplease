//
//  NetworkServiceTests.swift
//  RecipleaseTests
//
//  Created by Canessane Poudja on 22/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import XCTest
@testable import Reciplease

class NetworkServiceTests: XCTestCase {
    // MARK: Test fetchRecipeImage(urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void)

    func testFetchRecipeImage_ShouldFail_IfError() {
        let networkService = getNetworkServiceWithFakeNetworkRequest(data: nil, response: nil, error: FakeResponseData.error)
        networkService.fetchRecipeImage(urlString: url) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.getError)
            } else { XCTFail() }
        }
    }

    func testFetchRecipeImage_ShouldFail_IfNoData() {
        let networkService = getNetworkServiceWithFakeNetworkRequest(data: nil, response: nil, error: nil)
        networkService.fetchRecipeImage(urlString: url) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.noData)
            } else { XCTFail() }
        }
    }

    func testFetchRecipeImage_ShouldFail_IfNoResponse() {
        let networkService = getNetworkServiceWithFakeNetworkRequest(data: FakeResponseData.recipeCorrectImageData, response: nil, error: nil)
        networkService.fetchRecipeImage(urlString: url) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.noResponse)
            }
        }
    }

    func testFetchRecipeImage_ShouldFail_IfIncorrectResponse() {
        let networkService = getNetworkServiceWithFakeNetworkRequest(
            data: FakeResponseData.recipeCorrectImageData, response: FakeResponseData.responseKO, error: nil)
        networkService.fetchRecipeImage(urlString: url) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.badStatusCode)
            } else { XCTFail() }
        }
    }

    func testFetchRecipeImage_ShouldSucceed_IfNoErrorAndCorrectResponseAndCorrectData() {
        let networkService = getNetworkServiceWithFakeNetworkRequest(
            data: FakeResponseData.recipeCorrectImageData, response: FakeResponseData.responseOK, error: nil)
        networkService.fetchRecipeImage(urlString: url) { result in
            let data = try! result.get()
            XCTAssertEqual(data, FakeResponseData.recipeCorrectImageData)
        }
    }

    

    // MARK: Test fetchRecipes(urlString: String, completion: @escaping (Result<RecipeResult, NetworkError>) -> Void)

    func testFetchRecipes_ShouldFail_IfError() {
        let networkService = getNetworkServiceWithFakeNetworkRequest(data: nil, response: nil, error: FakeResponseData.error)
        networkService.fetchRecipes(urlString: url) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.getError)
            } else { XCTFail() }
        }
    }

    func testFetchRecipes_ShouldFail_IfNoData() {
        let networkService = getNetworkServiceWithFakeNetworkRequest(data: nil, response: nil, error: nil)
        networkService.fetchRecipes(urlString: url) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.noData)
            } else { XCTFail() }
        }
    }

    func testFetchRecipes_ShouldFail_IfNoResponse() {
        let networkService = getNetworkServiceWithFakeNetworkRequest(data: FakeResponseData.recipeCorrectData, response: nil, error: nil)
        networkService.fetchRecipes(urlString: url) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.noResponse)
            } else { XCTFail() }
        }
    }

    func testFetchRecipes_ShouldFail_IfIncorrectResponse() {
        let networkService = getNetworkServiceWithFakeNetworkRequest(
            data: FakeResponseData.recipeCorrectData, response: FakeResponseData.responseKO, error: nil)
        networkService.fetchRecipes(urlString: url) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.badStatusCode)
            } else { XCTFail() }
        }
    }

    func testFetchRecipes_ShouldFail_IfIncorrectData() {
        let networkService = getNetworkServiceWithFakeNetworkRequest(
            data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil)
        networkService.fetchRecipes(urlString: url) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.cannotDecodeData)
            } else { XCTFail() }
        }
    }

    func testFetchRecipes_ShouldFail_IfNoErrorAndCorrectResponseAndCorrectData() {
        let networkService = getNetworkServiceWithFakeNetworkRequest(
            data: FakeResponseData.recipeCorrectData, response: FakeResponseData.responseOK, error: nil)
        networkService.fetchRecipes(urlString: url) { result in
            if case .success(let recipes) = result {
                XCTAssertEqual(recipes, self.correctRecipes)
            } else { XCTFail() }
        }
    }



    // MARK: Tools

    private let url = "http://openclassrooms.com"

    private let correctRecipes: RecipeResult = RecipeResult(q: "Potatoe", from: 0, to: 3, hits: [
            Hit(recipe: Recipe(
                label: "Potato Cake",
                image: "https://www.edamam.com/web-img/423/423c241952e0319d3cc78a5bee04fba9.jpg",
                url: "http://notwithoutsalt.com/dating-my-husband-peanut-butter-pie/",
                yield: 6.0,
                ingredientLines: ["5 (or so) potatoes (i used new potatoes)","1 red pepper","1 small onion","1 stick butter, melted","5 sprigs of thyme, leaves removed","Salt and pepper"],
                calories: 1145.33426,
                totalTime: 0.0)),
            Hit(recipe: Recipe(
                label: "Roast potatoes",
                image: "https://www.edamam.com/web-img/a49/a49a0841acee748bc2b18d02ad86cd94.jpg",
                url: "http://www.bbc.co.uk/food/recipes/roastpotatoes_8818",
                yield: 8.0,
                ingredientLines: ["1kg/2½lb floury potatoes, such as maris piper","Olive oil or goose fat"],
                calories: 890.224,
                totalTime: 150.0)),
            Hit(recipe: Recipe(
                label: "Potato Chips",
                image: "https://www.edamam.com/web-img/29c/29c6193eac9df6e3d2bc3eb01e0a2d9a.jpg",
                url: "http://www.saveur.com/article/Recipes/Potato-Chips",
                yield: 4.0,
                ingredientLines: ["3 lbs. Idaho potatoes, peeled","Peanut oil","Salt"],
                calories: 1211.39644197264,
                totalTime: 0.0))
        ])

    private func getNetworkServiceWithFakeNetworkRequest(
        data: Data?,
        response: HTTPURLResponse?,
        error: Error?) -> NetworkServiceImplementation {

        let fakeNetworkRequest = FakeNetworkRequest(data: data, response: response, error: error)
        let networkService = NetworkServiceImplementation(networkRequest: fakeNetworkRequest)
        return networkService
    }
}
