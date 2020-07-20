//
//  FavoriteRecipeDataManagerTests.swift
//  RecipleaseTests
//
//  Created by Canessane Poudja on 18/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import XCTest
@testable import Reciplease

class FavoriteRecipeDataManagerTests: XCTestCase {
    var favoriteRecipeDataManager: FavoriteRecipeDataManager!
    let url = "http://notwithoutsalt.com/dating-my-husband-peanut-butter-pie/"

    override func setUp() {
        super.setUp()
        favoriteRecipeDataManager = FavoriteRecipeDataManager()
    }

    override func tearDown() {
        super.tearDown()
        try! favoriteRecipeDataManager.deleteFavoriteRecipe(withUrl: url)
    }

    func testSaveRecipeWithImageAndGetAllFavoriteRecipe() {
        let recipeWithImage = getRecipeWithImage()
        try! favoriteRecipeDataManager.save(recipeWithImage)
        let favoriteRecipes = favoriteRecipeDataManager.getAll()

        XCTAssertEqual(favoriteRecipes.count, 1)
        XCTAssertEqual(favoriteRecipes.first?.url, url)
    }

    func testDeleteFavoriteRecipe() {
        let recipeWithImage = getRecipeWithImage()
        try! favoriteRecipeDataManager.save(recipeWithImage)
        try! favoriteRecipeDataManager.deleteFavoriteRecipe(withUrl: url)
        let favoriteRecipes = favoriteRecipeDataManager.getAll()

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



    // MARK: Tools

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
}
