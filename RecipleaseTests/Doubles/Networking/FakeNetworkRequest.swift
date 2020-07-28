//
//  FakeNetworkRequest.swift
//  RecipleaseTests
//
//  Created by Canessane Poudja on 20/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Alamofire
@testable import Reciplease

struct FakeNetworkRequest: NetworkRequest {
    var data: Data?
    var response: HTTPURLResponse?
    var error: Error?

    func download(urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard error == nil else { return completion(.failure(.getError)) }
        guard let data = data else { return completion(.failure(.noData)) }
        guard let response = response else { return completion(.failure(.noResponse)) }
        guard 200...299 ~= response.statusCode else { return completion(.failure(.badStatusCode)) }

        completion(.success(data))
    }
}
