//
//  SettingsServiceTests.swift
//  RecipleaseTests
//
//  Created by Canessane Poudja on 18/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import XCTest
@testable import Reciplease

class SettingsServiceTests: XCTestCase {
    lazy var settingsService = SettingsService(userDefaults: userDefaults!)

    override func tearDown() {
        super.tearDown()
        userDefaults!.removePersistentDomain(forName: userDefaultsSuiteName)
    }

    func testSetIsOn_AndGetIsOn() {
        settingsService.setIsOn(to: false, forKey: .alcoholFree)
        let isOn = settingsService.getIsOn(forKey: .alcoholFree)

        XCTAssertFalse(isOn)
    }

    func testSetMinAndMaxValue_GetMinValue_AndGetMaxValue() {
        let dict = [
            SettingsService.DictKey.minValue.rawValue: 100,
            SettingsService.DictKey.maxValue.rawValue: 300
        ]

        settingsService.setMinAndMaxValues(to: dict, forKey: .calories)
        let minValue = settingsService.getMinValue(forKey: .calories)
        let maxValue = settingsService.getMaxValue(forKey: .calories)

        XCTAssertEqual(minValue, 100)
        XCTAssertEqual(maxValue, 300)
    }

    func testSetMin_MaxValue_GetMinValue_AndGetMaxValue_FaillureCase() {
        let dict = [
            SettingsService.DictKey.minValue.rawValue: 100,
            SettingsService.DictKey.maxValue.rawValue: 300
        ]

        settingsService.setMinAndMaxValues(to: dict, forKey: .alcoholFree)
        let minValue = settingsService.getMinValue(forKey: .calories)
        let maxValue = settingsService.getMaxValue(forKey: .calories)

        XCTAssertNotEqual(minValue, 100)
        XCTAssertNotEqual(maxValue, 300)
        XCTAssertEqual(minValue, 0)
        XCTAssertEqual(maxValue, 360)
    }



    // MARK: Tools

    private let userDefaultsSuiteName = "TestDefaults"
    private lazy var userDefaults = UserDefaults(suiteName: userDefaultsSuiteName)
}
