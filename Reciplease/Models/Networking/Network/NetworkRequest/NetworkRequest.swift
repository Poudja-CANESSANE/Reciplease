//
//  Networkrequest.swift
//  Reciplease
//
//  Created by Canessane Poudja on 21/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

protocol NetworkRequest {
    func download(urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void)
}
