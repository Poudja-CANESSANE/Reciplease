//
//  UrlProviderImplementation.swift
//  Reciplease
//
//  Created by Canessane Poudja on 27/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class UrlProviderImplementation: UrlProvider {
    func getUrl(forFood food: String) -> URL? {
        guard var url = URLComponents(
            string: "https://api.edamam.com/search?app_id=18ef1ba0&app_key=a6dd1b7f5987808e49bd2019a1f5468d&to=50")
            else {
                return nil
        }

        url.queryItems?.append(URLQueryItem(name: "q", value: food))
        print("\(String(describing: url.url)) " + #function)
        return url.url
    }
}
