//
//  NetworkService.swift
//  Reciplease
//
//  Created by Canessane Poudja on 27/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

protocol NetworkService {
    func fetchData(url: URL, completion: @escaping (Result<RecipeResult, NetworkError>) -> Void)
    func fetchData(url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void)
}
