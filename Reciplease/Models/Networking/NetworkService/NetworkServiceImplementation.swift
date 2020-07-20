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

    init(session: Session = AF) {
        self.session = session
    }



    // MARK: Methods

    ///Returns by the completion parameter the downloaded RecipeResult from the given URL
    func fetchRecipes(urlString: String, completion: @escaping (Result<RecipeResult, CustomError>) -> Void) {
        dowload(urlString: urlString) { result in
            switch result {
            case .failure(let networError):
                completion(.failure(networError))
            case .success(let data):
                guard let responseJSON = try? JSONDecoder().decode(RecipeResult.self, from: data) else {
                    completion(.failure(.cannotDecodeData))
                    return
                }

                completion(.success(responseJSON))
            }
        }
    }

    ///Returns by the completion parameter the downloaded Data from the given URL
    func fetchRecipeImage(urlString: String, completion: @escaping (Result<Data, CustomError>) -> Void) {
        dowload(urlString: urlString) { result in
            switch result {
            case .failure(let networError):
                completion(.failure(networError))
            case .success(let data):
                completion(.success(data))
            }
        }
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private let session: Session



    // MARK: Methods

    ///Checks if the response of the network call has no error, has data and if the statusCode is equal to 200
    ///then returns by the completion parameter the downloaded Data
    private func dowload(urlString: String, completion: @escaping (Result<Data, CustomError>) -> Void) {
        session.request(urlString).validate().responseData { dataResponse in
            guard let data = dataResponse.value else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }
    }
}
