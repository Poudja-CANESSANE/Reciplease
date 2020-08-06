//
//  FavoriteRecipeDataManagerTests.swift
//  RecipleaseTests
//
//  Created by Canessane Poudja on 18/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import XCTest
import CoreData
@testable import Reciplease

class FavoriteRecipeDataManagerTests: XCTestCase {
    var favoriteRecipeDataManager: FavoriteRecipeDataManager!

    override func setUp() {
        super.setUp()
        assignNewValueToFavoriteRecipeCoreDataManager()
    }

    override func tearDown() {
        super.tearDown()
        try! ContextProviderStub.persistentStoreDestroyer.destroyAllDataIfExist()
        try! favoriteRecipeDataManager.deleteFavoriteRecipe(withUrl: url)
    }

    func testSaveRecipeWithImage_AndGetAllFavoriteRecipe() {
        let recipeWithImage = getRecipeWithImage()
        try! favoriteRecipeDataManager.save(recipeWithImage)
        let favoriteRecipes = try! favoriteRecipeDataManager.getAll()

        XCTAssertEqual(favoriteRecipes.count, 1)
        XCTAssertEqual(favoriteRecipes.first?.url, url)
    }

    func testDeleteFavoriteRecipe() {
        let recipeWithImage = getRecipeWithImage()
        try! favoriteRecipeDataManager.save(recipeWithImage)
        try! favoriteRecipeDataManager.deleteFavoriteRecipe(withUrl: url)
        let favoriteRecipes = try! favoriteRecipeDataManager.getAll()

        XCTAssertTrue(favoriteRecipes.isEmpty)
    }

    func testGivenSavedRecipe_WhenIsFavoriteIsCalled_ThenReturnsTrue() {
        let recipeWithImage = getRecipeWithImage()
        try! favoriteRecipeDataManager.save(recipeWithImage)

        let isFavorite = try! favoriteRecipeDataManager.isFavorite(recipeUrl: url)

        XCTAssertTrue(isFavorite)
    }

    func testGivenNoRecipeSaved_WhenIsFavoriteIsCalled_ThenReturnsFalse() {
        let isFavorite = try! favoriteRecipeDataManager.isFavorite(recipeUrl: url)

        XCTAssertFalse(isFavorite)
    }

    func testGivenFavoriteRecipeDataManagerWithContextProviderStub_WhenSave_ThenShouldThrowError() {
        let favoriteRecipeDataManagerStub = getFavoriteRecipeDataManagerWithContextProviderStub()
        let recipeWithImage = getRecipeWithImage()

        XCTAssertThrowsError(try favoriteRecipeDataManagerStub.save(recipeWithImage)) { error in
            XCTAssertEqual(error as! CoreDataError, CoreDataError.getErrorSavingContext)
        }
    }

    func testGivenFavoriteRecipeDataManagerWithContextProviderStub_WhenGetAll_ThenShouldThrowError() {
        let favoriteRecipeDataManagerStub = getFavoriteRecipeDataManagerWithContextProviderStub()

        XCTAssertThrowsError(try favoriteRecipeDataManagerStub.getAll()) { error in
            XCTAssertEqual(error as! CoreDataError, CoreDataError.getErrorWhileFetchingFromCoreData)
        }
    }

    func testGivenFavoriteRecipeDataManagerWithContextProviderStub_WhenDeleteFavoriteRecipe_ThenShouldThrowError() {
        let favoriteRecipeDataManagerStub = getFavoriteRecipeDataManagerWithContextProviderStub()

        XCTAssertThrowsError(try favoriteRecipeDataManagerStub.deleteFavoriteRecipe(withUrl: url)) { error in
            XCTAssertEqual(error as! CoreDataError, CoreDataError.getErrorWhileFetchingFromCoreData)
        }
    }

    func testGivenFavoriteRecipeDataManagerWithContextProviderSaveStub_WhenDeleteFavoriteRecipe_ThenShouldThrowError() {
        let favoriteRecipeDataManagerStub = getFavoriteRecipeDataManagerWithContextProviderSaveStub()

        XCTAssertThrowsError(try favoriteRecipeDataManagerStub.deleteFavoriteRecipe(withUrl: url)) { error in
            XCTAssertEqual(error as! CoreDataError, CoreDataError.getErrorSavingContext)
        }
    }

    func testGivenFavoriteRecipeDataManagerWithContextProviderStub_WhenIfFavorite_ThenShouldThrowError() {
        let favoriteRecipeDataManagerStub = getFavoriteRecipeDataManagerWithContextProviderStub()

        XCTAssertThrowsError(try favoriteRecipeDataManagerStub.isFavorite(recipeUrl: url)) { error in
            XCTAssertEqual(error as! CoreDataError, CoreDataError.getErrorWhileFetchingFromCoreData)
        }
    }



    // MARK: Tools

    private let url = "http://notwithoutsalt.com/dating-my-husband-peanut-butter-pie/"

    private func assignNewValueToFavoriteRecipeCoreDataManager() {
        let contextProvider = ContextProviderImplementation(
            context: ContextProviderStub.mockContext,
            persistentStoreDestroyer: ContextProviderStub.persistentStoreDestroyer)
        let coreDataManager = CoreDataManager(contextProvider: contextProvider)
        favoriteRecipeDataManager = FavoriteRecipeDataManager(coreDataManager: coreDataManager)
    }


    private func getRecipeWithImage() -> RecipeWithImage {
        let recipe = RecipeObject(
            imageUrl: "https://www.edamam.com/web-img/423/423c241952e0319d3cc78a5bee04fba9.jpg",
            name: "Potato Cake",
            time: "0",
            calories: "1 145",
            url: url,
            ingredientLines: "- 5 (or so) potatoes (i used new potatoes)\n- 1 red pepper\n- 1 small onion\n- 1 stick butter, melted\n- 5 sprigs of thyme, leaves removed\n- Salt and pepper",
            yield: "6")

        let image = UIImage.defaultRecipeImage
        let recipeWithImage = RecipeWithImage(recipe: recipe, image: image)
        return recipeWithImage
    }

    private func getFavoriteRecipeDataManagerWithContextProviderStub() -> FavoriteRecipeDataManager {
        let coreDataManager = CoreDataManager(contextProvider: ContextProviderStub())
        let favoriteRecipeDataManager = FavoriteRecipeDataManager(coreDataManager: coreDataManager)
        return favoriteRecipeDataManager
    }

    private func getFavoriteRecipeDataManagerWithContextProviderSaveStub() -> FavoriteRecipeDataManager {
        let coreDataManager = CoreDataManager(contextProvider: ContextProviderSaveStub())
        let favoriteRecipeDataManager = FavoriteRecipeDataManager(coreDataManager: coreDataManager)
        return favoriteRecipeDataManager
    }
}
