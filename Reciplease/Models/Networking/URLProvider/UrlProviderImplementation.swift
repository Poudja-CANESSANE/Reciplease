//
//  UrlProviderImplementation.swift
//  Reciplease
//
//  Created by Canessane Poudja on 27/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class UrlProviderImplementation: UrlProvider {
    // MARK: - INTERNAL

    // MARK: Methods

    func getUrlString(forFood food: String, fromMinIndex minIndex: Int, toMaxIndex maxIndex: Int) -> String? {
        guard let url = URLComponents(
            string: "https://api.edamam.com/search?app_id=18ef1ba0&app_key=a6dd1b7f5987808e49bd2019a1f5468d")
            else { return nil }

        let minIndexString = String(minIndex)
        let maxIndexString = String(maxIndex)

        let fullUrl = appendURLQueryItems(
            toUrl: url,
            food: food,
            minIndexString: minIndexString,
            maxIndexString: maxIndexString)

        let urlString = fullUrl.url?.absoluteString
        print("\(String(describing: fullUrl.url?.absoluteString)) " + #function)
        return urlString
    }



    // MARK: - PRIVATE

    // MARK: Methods

    private func appendURLQueryItems(
        toUrl url: URLComponents,
        food: String,
        minIndexString: String,
        maxIndexString: String) -> URLComponents {
        
        var url = url
        url.queryItems?.append(URLQueryItem(name: "q", value: food))
        url.queryItems?.append(URLQueryItem(name: "from", value: minIndexString))
        url.queryItems?.append(URLQueryItem(name: "to", value: maxIndexString))

        SettingsService.Keys.allCases.forEach {
            if SettingsService.getIsOn(forKey: $0) {
                url.queryItems?.append(URLQueryItem(name: $0.urlName, value: $0.urlValue))
            }
        }

        return url
    }
}
