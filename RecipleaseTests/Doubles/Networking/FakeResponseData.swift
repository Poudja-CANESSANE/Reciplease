//
//  FakeResponseData.swift
//  RecipleaseTests
//
//  Created by Canessane Poudja on 21/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit
@testable import Reciplease

class FakeResponseData {
    // MARK: Correct Data

    static var recipeCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)

        guard let url = bundle.url(forResource: "Recipe", withExtension: "json") else {
            fatalError("No such resource: Recipe.json from bundle.")
        }

        guard let recipeData = try? Data(contentsOf: url) else {
            fatalError("Failed to load Recipe.json from bundle.")
        }

        return recipeData
    }

    static let recipeCorrectImageData = UIImage(named: "recipeCorrectImage")!.pngData()



    // MARK: Incorrect Data

    static let incorrectData = "error".data(using: .utf8)

    static let incorrectImageData = UIImage.defaultRecipeImage.pngData()



    // MARK: Response

    static let responseOK = HTTPURLResponse(url: URL(
        string: "http://openclassrooms.com")!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil)

    static let responseKO = HTTPURLResponse(url: URL(
        string: "http://openclassrooms.com")!,
        statusCode: 500,
        httpVersion: nil,
        headerFields: nil)




    // MARK: Error

    class FakeResponseError: Error {}
    static let error = FakeResponseError()
}
