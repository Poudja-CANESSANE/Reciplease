//
//  NetworkServiceImplementation.swift
//  Reciplease
//
//  Created by Canessane Poudja on 27/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Alamofire

class NetworkServiceImplementation: NetworkService {
    // MARK: - INTERNAL

    // MARK: Inits

    init(networkRequest: NetworkRequest = ServiceContainer.alamofireNetworkRequest) {
        self.networkRequest = networkRequest
    }



    // MARK: Methods

    ///Returns by the completion parameter the downloaded data decoded in the given type from the given URL
    func fetchDecodedData<T: Codable>(urlString: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        networkRequest.download(urlString: urlString) { result in
            switch result {
            case .failure(let networkError):
                completion(.failure(networkError))
            case .success(let data):
                guard let responseJSON = try? JSONDecoder().decode(T.self, from: data) else {
                    return completion(.failure(.cannotDecodeData))
                }

                completion(.success(responseJSON))
            }
        }
    }

    ///Returns by the completion parameter the downloaded Data from the given URL
    func fetchData(urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        networkRequest.download(urlString: urlString) { result in
            switch result {
            case .failure(let networkError): completion(.failure(networkError))
            case .success(let data): completion(.success(data))
            }
        }
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private let networkRequest: NetworkRequest
}
