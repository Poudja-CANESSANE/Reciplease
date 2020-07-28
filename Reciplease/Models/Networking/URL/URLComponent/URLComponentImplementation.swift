//
//  URLComponentImplementation.swift
//  Reciplease
//
//  Created by Canessane Poudja on 26/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class URLComponentImplementation: URLComponent {
    ///Returns an optional URLComponents by calling the its init(string: String) method
    func getBaseUrl(fromString string: String) -> URLComponents? {
        URLComponents(string: string)
    }
}
