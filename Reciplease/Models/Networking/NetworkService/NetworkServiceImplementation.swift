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

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }



    // MARK: Methods

    ///Returns by the completion parameter the downloaded Data of generic type from the given URL
    func fetchData(url: URL, completion: @escaping (Result<RecipeResult, NetworkError>) -> Void) {
        session.dataTask(with: url) { (data, response, error) in
            self.verifyResponse(data: data, response: response, error: error) { result in
                switch result {
                case .failure(let networkError):
                    completion(.failure(networkError))
                case .success(let data):
                    guard let responseJSON = try? JSONDecoder().decode(RecipeResult.self, from: data) else {
                        completion(.failure(.cannotDecodeData))
                        return
                    }

                    completion(.success(responseJSON))
                }
            }
        }.resume()
    }

    ///Returns by the completion parameter the downloded Data from the given URL
    func fetchData(url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        session.dataTask(with: url) { (data, response, error) in
            self.verifyResponse(data: data, response: response, error: error) { result in
                switch result {
                case .failure(let networkError): completion(.failure(networkError))
                case .success(let data): completion(.success(data))
                }
            }
        }.resume()
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private var session: URLSession



    // MARK: Methods

    ///Checks if the response of the network call has no error, has data and if the statusCode is equal to 200
    ///then returns by the completion parameter the downloaded Data
    private func verifyResponse(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        completion: (Result<Data, NetworkError>) -> Void) {

        guard error == nil else {
            completion(.failure(.getError))
            return
        }
        guard let data = data else {
            completion(.failure(.noData))
            return
        }

        guard let response = response as? HTTPURLResponse else {
            completion(.failure(.noResponse))
            return
        }

        guard response.statusCode == 200 else {
            completion(.failure(.badStatusCode))
            return
        }

        completion(.success(data))
    }
}
