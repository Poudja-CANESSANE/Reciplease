//
//  SettingdService.swift
//  Reciplease
//
//  Created by Canessane Poudja on 05/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

class SettingsService {
    enum Keys: Int, CaseIterable {
        // MARK: - INTERNAL

        case balanced, highProtein, lowFat, lowCarb
        case vegan, vegetarian, peanutFree, treeNutFree, alcoholFree, immunoSupportive, sugarConscious



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
            }
        }

        var urlName: String {
            return isDiet ? "diet" : "health"
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
            }
        }



        // MARK: - PRIVATE

        // MARK: Properties

        private var isDiet: Bool {
            self == .balanced || self == .highProtein || self == .lowFat || self == .lowCarb
        }
    }



    static func getIsOn(forKey key: Keys) -> Bool {
        UserDefaults.standard.bool(forKey: key.name)
    }

    static func setIsOn(to bool: Bool, forKey key: Keys) {
        UserDefaults.standard.set(bool, forKey: key.name)
    }
}
