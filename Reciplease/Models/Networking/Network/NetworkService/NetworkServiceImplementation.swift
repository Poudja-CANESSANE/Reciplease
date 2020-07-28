//
//  NetworkServiceImplementation.swift
//  Reciplease
//
//  Created by Canessane Poudja on 27/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation
import Alamofire

class NetworkServiceImplementation: NetworkService {
    // MARK: - INTERNAL

    // MARK: Inits

    init(networkRequest: NetworkRequest = ServiceContainer.alamofireNetworkRequest) {
        self.networkRequest = networkRequest
    }



    // MARK: Methods

    ///Returns by the completion parameter the downloaded RecipeResult from the given URL
    func fetchRecipes(urlString: String, completion: @escaping (Result<RecipeResult, NetworkError>) -> Void) {
        networkRequest.download(urlString: urlString) { result in
            switch result {
            case .failure(let networError):
                completion(.failure(networError))
            case .success(let data):
                guard let responseJSON = try? JSONDecoder().decode(RecipeResult.self, from: data) else {
                    return completion(.failure(.cannotDecodeData))
                }

                completion(.success(responseJSON))
            }
        }
    }

    ///Returns by the completion parameter the downloaded Data from the given URL
    func fetchRecipeImage(urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        networkRequest.download(urlString: urlString) { result in
            switch result {
            case .failure(let networError): completion(.failure(networError))
            case .success(let data): completion(.success(data))
            }
        }
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private let networkRequest: NetworkRequest
}
