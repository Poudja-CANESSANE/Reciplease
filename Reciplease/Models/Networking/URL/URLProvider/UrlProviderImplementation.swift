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

    // MARK: Inits

    init(settingsService: SettingsService = ServiceContainer.settingsService,
         urlValueProvider: UrlValueProvider = ServiceContainer.urlValueProvider,
         urlComponent: URLComponent = ServiceContainer.urlComponent) {
        self.settingsService = settingsService
        self.urlValueProvider = urlValueProvider
        self.urlComponent = urlComponent
    }



    // MARK: Methods

    ///Returns the url's absoluteString build from the given food, minIndex, maxIndex and settingsService's parameters
    func getUrlString(forFood food: String, fromMinIndex minIndex: Int, toMaxIndex maxIndex: Int) -> String? {
        guard let url = urlComponent.getBaseUrl(fromString:
            "https://api.edamam.com/search?app_id=18ef1ba0&app_key=a6dd1b7f5987808e49bd2019a1f5468d")
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

    // MARK: Properties

    private let settingsService: SettingsService
    private let urlValueProvider: UrlValueProvider
    private let urlComponent: URLComponent



    // MARK: Methods

    ///Returns an URLComponents build by appending the given food, minIndex, maxIndex
    ///and settingsService's parameters to the given url
    private func appendURLQueryItems(
        toUrl url: URLComponents,
        food: String,
        minIndexString: String,
        maxIndexString: String) -> URLComponents {
        
       let urlWithBaseParameters = appendURLQueryItemsFromParameters(
            toUrl: url,
            food: food,
            minIndexString: minIndexString,
            maxIndexString: maxIndexString)

        let urlWithSwitchesParameters = appendURLQueryItemsFromSwitches(toUrl: urlWithBaseParameters)
        let fullUrl = appendURLQueryItemsFromRangeSeekSliders(toUrl: urlWithSwitchesParameters)

        return fullUrl

    }

    ///Returns an URLComponents build by appending the given food, minIndex and maxIndex to the given url
    private func appendURLQueryItemsFromParameters(
        toUrl url: URLComponents,
        food: String,
        minIndexString: String,
        maxIndexString: String) -> URLComponents {

        var url = url
        url.queryItems?.append(URLQueryItem(name: "q", value: food))
        url.queryItems?.append(URLQueryItem(name: "from", value: minIndexString))
        url.queryItems?.append(URLQueryItem(name: "to", value: maxIndexString))
        return url
    }

    ///Returns an URLComponents build by appending URLQueryItem to the given url
    ///according to the switches' state from the settingsService
    private func appendURLQueryItemsFromSwitches(toUrl url: URLComponents) -> URLComponents {
        var url = url
        SettingsService.Key.allCases.forEach {
            if settingsService.getIsOn(forKey: $0) {
                let urlValue = urlValueProvider.getUrlValue(forKey: $0)
                url.queryItems?.append(URLQueryItem(name: $0.urlName, value: urlValue))
            }
        }
        return url
    }

    ///Returns an URLComponents build by appending URLQueryItem to the given url
    ///according the SettingsService.Key's calories and time cases
    private func appendURLQueryItemsFromRangeSeekSliders(toUrl url: URLComponents) -> URLComponents {
        var url = url
        let caloriesKey = SettingsService.Key.calories
        let timeKey = SettingsService.Key.time

        let caloriesUrlValue = urlValueProvider.getUrlValue(forKey: .calories)
        let timeUrlValue = urlValueProvider.getUrlValue(forKey: .time)

        url.queryItems?.append(URLQueryItem(name: caloriesKey.urlName, value: caloriesUrlValue))
        url.queryItems?.append(URLQueryItem(name: timeKey.urlName, value: timeUrlValue))
        return url
    }
}
