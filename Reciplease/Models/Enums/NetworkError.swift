//
//  NetworkError.swift
//  Reciplease
//
//  Created by Canessane Poudja on 22/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case cannotGetUrl
    case noData
    case getError
    case noResponse
    case badStatusCode
    case cannotDecodeData

    var message: String {
        switch self {
        case .cannotGetUrl: return "The URL is wrong !"
        case .badStatusCode: return "The response status code is not 200 !"
        case .cannotDecodeData: return "The data decoding is impossible !"
        case .getError: return "An error occurred while getting the response !"
        case .noData: return "There is no data !\nCheck your internet connection or change your settings."
        case .noResponse: return "There is no response !"
        }
    }
}
