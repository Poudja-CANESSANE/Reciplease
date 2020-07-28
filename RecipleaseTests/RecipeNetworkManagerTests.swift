//
//  RecipeNetworkManagerTests.swift
//  RecipleaseTests
//
//  Created by Canessane Poudja on 18/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import XCTest
@testable import Reciplease

class RecipeNetworkManagerTests: XCTestCase {
    override func tearDown() {
        super.tearDown()
        userDefaults!.removePersistentDomain(forName: userDefaultsSuiteName)
    }

    // MARK: Test getRecipeImage(fromImageUrlString imageUrlString: String, completion: @escaping RecipeImageCompletion)

    func testGetRecipeImage_ShouldFail_IfError() {
        let recipeNetworkManager = getRecipeNetworkManager(
            data: nil, response: nil, error: FakeResponseData.error)

        recipeNetworkManager.getRecipeImage(fromImageUrlString: url) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.getError)
            } else { XCTFail() }
        }
    }

    func testGetRecipeImage_ShouldFail_IfNoData() {
        let recipeNetworkManager = getRecipeNetworkManager(
            data: nil, response: nil, error: nil)

        recipeNetworkManager.getRecipeImage(fromImageUrlString: url) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.noData)
            } else { XCTFail() }
        }
    }

    func testGetRecipeImage_ShouldFail_IfNoResponse() {
        let recipeNetworkManager = getRecipeNetworkManager(
            data: FakeResponseData.recipeCorrectImageData, response: nil, error: nil)

        recipeNetworkManager.getRecipeImage(fromImageUrlString: url) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.noResponse)
            } else { XCTFail() }
        }
    }

    func testGetRecipeImage_ShouldFail_IfIncorrectResponse() {
        let recipeNetworkManager = getRecipeNetworkManager(
            data: FakeResponseData.recipeCorrectImageData, response: FakeResponseData.responseKO, error: nil)

        recipeNetworkManager.getRecipeImage(fromImageUrlString: url) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.badStatusCode)
            } else { XCTFail() }
        }
    }

    func testGetRecipeImage_ShouldSucceed_IfNoErrorAndCorrectResponseAndCorrectData() {
        let recipeNetworkManager = getRecipeNetworkManager(data: FakeResponseData.recipeCorrectImageData, response: FakeResponseData.responseOK, error: nil)

        recipeNetworkManager.getRecipeImage(fromImageUrlString: url) { result in
            let data = try! result.get()
            XCTAssertEqual(data, FakeResponseData.recipeCorrectImageData)
        }
    }



    // MARK: Test getRecipes(forFoods foods: String, fromMinIndex minIndex: Int,ctoMaxIndex maxIndex: Int, completion: @escaping RecipeCompletion)

    func testGetRecipes_ShouldFail_IfError() {
        let recipeNetworkManager = getRecipeNetworkManager(
            data: nil, response: nil, error: FakeResponseData.error)

        recipeNetworkManager.getRecipes(forFoods: "Potatoe", fromMinIndex: 0, toMaxIndex: 3) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.getError)
            } else { XCTFail() }
        }
    }

    func testGetRecipes_ShouldFail_IfNoData() {
        let recipeNetworkManager = getRecipeNetworkManager(
            data: nil, response: nil, error: nil)

        recipeNetworkManager.getRecipes(forFoods: "Potatoe", fromMinIndex: 0, toMaxIndex: 3) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.noData)
            } else { XCTFail() }
        }
    }

    func testGetRecipes_ShouldFail_IfNoResponse() {
        let recipeNetworkManager = getRecipeNetworkManager(
            data: FakeResponseData.recipeCorrectImageData, response: nil, error: nil)

        recipeNetworkManager.getRecipes(forFoods: "Potatoe", fromMinIndex: 0, toMaxIndex: 3) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.noResponse)
            } else { XCTFail() }
        }
    }

    func testGetRecipes_ShouldFail_IfIncorrectData() {
        let recipeNetworkManager = getRecipeNetworkManager(
            data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil)

        recipeNetworkManager.getRecipes(forFoods: "Potatoe", fromMinIndex: 0, toMaxIndex: 3) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.cannotDecodeData)
            } else { XCTFail() }
        }
    }

    func testGetRecipes_ShouldFail_IfIncorrectResponse() {
        let recipeNetworkManager = getRecipeNetworkManager(
            data: FakeResponseData.recipeCorrectImageData, response: FakeResponseData.responseKO, error: nil)

        recipeNetworkManager.getRecipes(forFoods: "Potatoe", fromMinIndex: 0, toMaxIndex: 3) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.badStatusCode)
            } else { XCTFail() }
        }
    }

    func testGetRecipes_ShouldFail_IfIncorrectUrl() {
        let recipeNetworkManager = getRecipeNetworkManagerWithStubUrlProvider()

        recipeNetworkManager.getRecipes(forFoods: "Potatoe", fromMinIndex: 0, toMaxIndex: 3) { result in
            if case .failure(let networkError) = result {
                XCTAssertEqual(networkError, NetworkError.cannotGetUrl)
            } else { XCTFail() }
        }
    }

    func testGetRecipes_ShouldSucceed_IfNoErrorAndCorrectResponseAndCorrectData() {
        let recipeNetworkManager = getRecipeNetworkManager(data: FakeResponseData.recipeCorrectData, response: FakeResponseData.responseOK, error: nil)

        recipeNetworkManager.getRecipes(forFoods: "Potatoe", fromMinIndex: 0, toMaxIndex: 3) { result in
            let recipes = try! result.get()
            XCTAssertEqual(recipes, self.correctRecipes)
        }
    }

    func testGetRecipesWithStubFormatters() {
        let recipeNetworkManager = getRecipeNetworkManagerWithStubFormatters()

        recipeNetworkManager.getRecipes(forFoods: "Potatoe", fromMinIndex: 0, toMaxIndex: 3) { result in
            let recipes = try! result.get()
            let firstRecipe = recipes[0]
            let secondRecipe = recipes[1]
            let thirdRecipe = recipes[2]

            XCTAssertEqual(firstRecipe.time, "N/A")
            XCTAssertEqual(secondRecipe.time, "Error")
            XCTAssertEqual(thirdRecipe.time, "N/A")
            XCTAssertEqual(firstRecipe.calories, "NaN")
            XCTAssertEqual(secondRecipe.calories, "NaN")
            XCTAssertEqual(thirdRecipe.calories, "NaN")
        }
    }

    // MARK: Tools

    private let url = "http://openclassrooms.com"
    private let userDefaultsSuiteName = "TestDefaults"
    lazy private var userDefaults = UserDefaults(suiteName: userDefaultsSuiteName)
    lazy private var settingsService = SettingsService(userDefaults: userDefaults!)

    private let correctRecipes = [
        RecipeObject(
            imageUrl: "https://www.edamam.com/web-img/423/423c241952e0319d3cc78a5bee04fba9.jpg",
            name: "Potato Cake",
            time: "N/A",
            calories: "1 145",
            url: "http://notwithoutsalt.com/dating-my-husband-peanut-butter-pie/",
            ingredientLines: "- 5 (or so) potatoes (i used new potatoes)\n- 1 red pepper\n- 1 small onion\n- 1 stick butter, melted\n- 5 sprigs of thyme, leaves removed\n- Salt and pepper",
            yield: "6"),
        RecipeObject(
            imageUrl: "https://www.edamam.com/web-img/a49/a49a0841acee748bc2b18d02ad86cd94.jpg",
            name: "Roast potatoes",
            time: "2h 30m",
            calories: "890",
            url: "http://www.bbc.co.uk/food/recipes/roastpotatoes_8818",
            ingredientLines: "- 1kg/2½lb floury potatoes, such as maris piper\n- Olive oil or goose fat",
            yield: "8"),
        RecipeObject(
            imageUrl: "https://www.edamam.com/web-img/29c/29c6193eac9df6e3d2bc3eb01e0a2d9a.jpg",
            name: "Potato Chips",
            time: "N/A",
            calories: "1 211",
            url: "http://www.saveur.com/article/Recipes/Potato-Chips",
            ingredientLines: "- 3 lbs. Idaho potatoes, peeled\n- Peanut oil\n- Salt",
            yield: "4")
    ]

    ///Returns a CurrencyNetworkManager with a URLSessionFake from the given Data?, HTTPURLResponse? and Error?
    private func getRecipeNetworkManager(
        data: Data?,
        response: HTTPURLResponse?,
        error: Error?) -> RecipeNetworkManager {

        let fakeNetworkRequest = FakeNetworkRequest(data: data, response: response, error: error)

        let recipeNetworkManager = RecipeNetworkManager(
            networkService: NetworkServiceImplementation(networkRequest: fakeNetworkRequest),
            urlProvider: UrlProviderImplementation(
                settingsService: settingsService,
                urlValueProvider: UrlValueProvider(settingsService: settingsService)))

        return recipeNetworkManager
    }

    ///Returns a CurrencyNetworkManager with a URLSessionFake and a CurrencyUrlProviderStub
    private func getRecipeNetworkManagerWithStubUrlProvider() -> RecipeNetworkManager {
        let fakeNetworkRequest = FakeNetworkRequest(data: nil, response: nil, error: nil)

        let recipeNetworkManager = RecipeNetworkManager(
            networkService: NetworkServiceImplementation(networkRequest: fakeNetworkRequest),
            urlProvider: UrlProviderStub())

        return recipeNetworkManager
    }

    private func getRecipeNetworkManagerWithStubFormatters() -> RecipeNetworkManager {
        let fakeNetworkRequest = FakeNetworkRequest(data: FakeResponseData.recipeCorrectData, response: FakeResponseData.responseOK, error: nil)

        let recipeNetworkManager = RecipeNetworkManager(
            networkService: NetworkServiceImplementation(networkRequest: fakeNetworkRequest),
            urlProvider: UrlProviderImplementation(
                settingsService: settingsService,
                urlValueProvider: UrlValueProvider(settingsService: settingsService)),
            dateFormatter: DateComponentsFormatterStub(),
            numberFormatter: NumberFormatterStub())

        return recipeNetworkManager
    }
}
