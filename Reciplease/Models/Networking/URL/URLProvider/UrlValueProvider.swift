//swiftlint:disable cyclomatic_complexity
//  UrlValueProvider.swift
//  Reciplease
//
//  Created by Canessane Poudja on 22/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class UrlValueProvider {
    // MARK: - INTERNAL

    // MARK: Inits

    init(settingsService: SettingsService = ServiceContainer.settingsService) {
        self.settingsService = settingsService
    }



    // MARK: Methods

    ///Returns a String corresponding to the given key's urlValue
    func getUrlValue(forKey key: SettingsService.Key) -> String {
        switch key {
        case .alcoholFree: return "alcohol-free"
        case .balanced: return "balanced"
        case .highProtein: return "high-protein"
        case .immunoSupportive: return "immuno-supportive"
        case .lowCarb: return "low-carb"
        case .lowFat: return "low-fat"
        case .peanutFree: return "peanut-free"
        case .sugarConscious: return "sugar-conscious"
        case .treeNutFree: return "tree-nut-free"
        case .vegan: return "vegan"
        case .vegetarian: return "vegetarian"
        case .calories: return getRange(forKey: key)
        case .time: return getRange(forKey: key)
        }
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private let settingsService: SettingsService



    // MARK: Methods

    ///Retuens a String corresponding to the minimum and maximun values of calories or time RangeSeekSlider
    private func getRange(forKey key: SettingsService.Key) -> String {
        let minValueString = String(Int(settingsService.getMinValue(forKey: key)))
        let maxValueString = String(Int(settingsService.getMaxValue(forKey: key)))
        let range = minValueString + "-" + maxValueString
        return range
    }
}
