//
//  AlamofireNetworkRequest.swift
//  Reciplease
//
//  Created by Canessane Poudja on 21/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Alamofire

class AlamofireNetworkRequest: NetworkRequest {
    // MARK: - INTERNAL

    // MARK: Methods

    ///Checks if the response of the network call has no error, has data and if the statusCode is equal to 200
    ///then returns by the completion parameter the downloaded Data
    func download(urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        AF.request(urlString).responseData { dataResponse in
            guard dataResponse.error == nil else { return completion(.failure(.getError)) }
            guard let data = dataResponse.data else { return completion(.failure(.noData)) }
            guard let response = dataResponse.response else { return completion(.failure(.noResponse)) }
            guard 200...299 ~= response.statusCode else { return completion(.failure(.badStatusCode)) }

            completion(.success(data))
        }
    }
}
