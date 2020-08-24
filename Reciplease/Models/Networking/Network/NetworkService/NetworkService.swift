//
//  NetworkService.swift
//  Reciplease
//
//  Created by Canessane Poudja on 27/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

protocol NetworkService {
    func fetchDecodedData<T: Codable>(urlString: String, completion: @escaping (Result<T, NetworkError>) -> Void)
    func fetchData(urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void)
}
