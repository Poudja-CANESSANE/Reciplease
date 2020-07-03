//
//  NetworkError.swift
//  Reciplease
//
//  Created by Canessane Poudja on 27/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case cannotGetUrl
    case noData
    case cannotDecodeData
    case cannotUnwrapFirstHit
    case cannotGetImageUrlFromRecipe

    var message: String {
        switch self {
        case .cannotGetUrl: return "The URL is wrong !"
        case .cannotDecodeData: return "The data decoding is impossible !"
        case .noData: return "There is no data !"
        case .cannotUnwrapFirstHit: return "The unwrapping of the first Hit is impossible !"
        case .cannotGetImageUrlFromRecipe: return "Cannot get the image URL from the RecipeObject !"
        }
    }
}
