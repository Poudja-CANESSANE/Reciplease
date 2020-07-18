//
//  UrlProviderImplementationTests.swift
//  RecipleaseTests
//
//  Created by Canessane Poudja on 17/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import XCTest
@testable import Reciplease

class UrlProviderTests: XCTestCase {
    var userDefaults: UserDefaults!
    let userDefaultsSuiteName = "TestDefaults"
    var settingsService: SettingsService!
    var urlProvider: UrlProviderImplementation!
    var sut: UserDefaults!

    override func setUp() {
        super.setUp()
        UserDefaults().removePersistentDomain(forName: userDefaultsSuiteName)
        userDefaults = UserDefaults(suiteName: userDefaultsSuiteName)
        settingsService = SettingsService(userDefaults: userDefaults)
        urlProvider = UrlProviderImplementation(settingsService: SettingsService(userDefaults: userDefaults))
    }
    
    func testGetUrl() {
        SettingsService.Key.allCases.forEach { settingsService.setIsOn(to: true, forKey: $0) }
        let url = urlProvider.getUrlString(forFood: "Potatoe", fromMinIndex: 0, toMaxIndex: 50)
        XCTAssertEqual(url, "https://api.edamam.com/search?app_id=18ef1ba0&app_key=a6dd1b7f5987808e49bd2019a1f5468d&q=Potatoe&from=0&to=50&diet=balanced&diet=high-protein&diet=low-fat&diet=low-carb&health=vegan&health=vegetarian&health=peanut-free&health=tree-nut-free&health=alcohol-free&health=immuno-supportive&health=sugar-conscious&calories=0-360&time=0-360&calories=0-360&time=0-360") // swiftlint:disable:this line_length
    }
}
