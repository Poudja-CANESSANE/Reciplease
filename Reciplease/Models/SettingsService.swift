//
//  SettingsService.swift
//  Reciplease
//
//  Created by Canessane Poudja on 05/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class SettingsService {
    // MARK: - INTERNAL

    // MARK: Enums

    enum Key: Int, CaseIterable {
        // MARK: - INTERNAL

        case balanced, highProtein, lowFat, lowCarb
        case vegan, vegetarian, peanutFree, treeNutFree, alcoholFree, immunoSupportive, sugarConscious
        case calories, time



        // MARK: Properties

        var name: String {
            switch self {
            case .alcoholFree: return "Alcohol Free"
            case .balanced: return "Balanced"
            case .highProtein: return "High Protein"
            case .immunoSupportive: return "Immuno Supportive"
            case .lowCarb: return "Low Carb"
            case .lowFat: return "Low Fat"
            case .peanutFree: return "Peanut Free"
            case .sugarConscious: return "Sugar Conscious"
            case .treeNutFree: return "Tree Nut Free"
            case .vegan: return "Vegan"
            case .vegetarian: return "Vegetarian"
            case .calories: return "Calories"
            case .time: return "Time"
            }
        }

        var urlName: String {
            return isDiet ? "diet" : caloriesOrTimeOrHealth
        }

        var urlValue: String {
            switch self {
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
            case .calories: return getRange()
            case .time: return getRange()
            }
        }



//        init(settingsService: SettingsService) {
//            self.settingsService = settingsService
//        }

        // MARK: - PRIVATE

        // MARK: Properties

        private var isDiet: Bool {
            self == .balanced || self == .highProtein || self == .lowFat || self == .lowCarb
        }

        private var caloriesOrTimeOrHealth: String { isCalories ? "calories" : timeOrHealth }
        private var timeOrHealth: String { isTime ? "time" : "health" }
        private var isCalories: Bool { self == .calories }
        private var isTime: Bool { self == .time }

//        private var settingsService: SettingsService



        // MARK: Methods

        private func getRange() -> String {
            let minValueString = String(Int(ServiceContainer.settingsService.getMinValue(forKey: self)))
            let maxValueString = String(Int(ServiceContainer.settingsService.getMaxValue(forKey: self)))
            let range = minValueString + "-" + maxValueString
            return range
        }
    }

    enum DictKey: String { case minValue, maxValue }



    // MARK: Inits

    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }



    // MARK: Methods

    // MARK: UISwitch

    ///Returns a Bool corresponding to switches' activation state
    func getIsOn(forKey key: Key) -> Bool {
        userDefaults.bool(forKey: key.name)
    }

    ///Sets the given switch's activation state
    func setIsOn(to bool: Bool, forKey key: Key) {
        userDefaults.set(bool, forKey: key.name)
    }



    // MARK: RangeSeekSlider

    ///Returns an Int corresponding the minimum value of the given RangeSeekSlider
    func getMinValue(forKey key: Key) -> Int {
        guard let dict = userDefaults.dictionary(forKey: key.name) else { return 0 }
        let minValue = dict[DictKey.minValue.rawValue] as? Int ?? 0
        return minValue
    }

    ///Returns an Int corresponding to the maximum value of the given RangeSeekSlider
    func getMaxValue(forKey key: Key) -> Int {
        guard let dict = userDefaults.dictionary(forKey: key.name) else { return 360 }
        let maxValue = dict[DictKey.maxValue.rawValue] as? Int ?? 360
        return maxValue
    }

    ///Sets the minimum and maximum values of the given RangeSeekSlider
    func setMinAndMaxValues(to dict: [String: Int], forKey key: Key) {
        userDefaults.set(dict, forKey: key.name)
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private let userDefaults: UserDefaults
}
