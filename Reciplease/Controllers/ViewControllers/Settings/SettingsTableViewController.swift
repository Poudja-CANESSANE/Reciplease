//
//  SettingsViewController.swift
//  Reciplease
//
//  Created by Canessane Poudja on 04/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit
import RangeSeekSlider

class SettingsTableViewController: UITableViewController {
    // MARK: - INTERNAL

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setSwitchesActivation()
        setRangeSeekSlidersValues()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveSlidersSettings()
    }



    // MARK: - PRIVATE

    // MARK: IBOutlets

    @IBOutlet private var switches: [UISwitch]!
    @IBOutlet private var rangeSeekSliders: [RangeSeekSlider]!



    // MARK: IBActions

    @IBAction private func didSwitch(_ sender: UISwitch) {
        saveSwitchSetting(fromSender: sender)
    }



    // MARK: Properties

    private let alertManager = ServiceContainer.alertManager
    private let settingsService = ServiceContainer.settingsService



    // MARK: Methods

    ///Sets the switches' activation state
    private func setSwitchesActivation() {
        switches.forEach {
            if let key = SettingsService.Key(rawValue: $0.tag) {
                let isOn = settingsService.getIsOn(forKey: key)
                $0.isOn = isOn
            }
        }
    }

    ///Sets the minimum and maximum values of the 2 RangeSeekSliders
    private func setRangeSeekSlidersValues() {
        rangeSeekSliders.forEach {
            guard let key = getKey(fromSender: $0) else { return }
            $0.selectedMinValue = CGFloat(settingsService.getMinValue(forKey: key))
            $0.selectedMaxValue = CGFloat(settingsService.getMaxValue(forKey: key))
        }
    }

    ///Saves the given switch activation state in UserDefaults
    private func saveSwitchSetting(fromSender sender: UISwitch) {
        guard let key = getKey(fromSender: sender) else { return }
        settingsService.setIsOn(to: sender.isOn, forKey: key)
    }

    ///Saves the minimum and maximum values of the 2 RangeSeekSlider in UserDefaults
    private func saveSlidersSettings() {
        rangeSeekSliders.forEach { saveRangeSeekSliderSetting(fromSender: $0) }
    }

    ///Saves the minimum and maximum values of the given RangeSeekSlider in UserDefaults
    private func saveRangeSeekSliderSetting(fromSender sender: RangeSeekSlider) {
        guard let key = getKey(fromSender: sender) else { return }
        let dict = getDict(fromRangeSeekSlider: sender)
        settingsService.setMinAndMaxValues(to: dict, forKey: key)
    }

    ///Returns an optional SettingsService.Key from the given UIControl's tag
    private func getKey(fromSender sender: UIControl) -> SettingsService.Key? {
        guard let key = SettingsService.Key(rawValue: sender.tag) else {
            presentAlert(message: CoreDataError.cannotUnwrapKey.message)
            return nil
        }
        return key
    }

    ///Returns a dictionary of String and Int containing the minimum and the maximum values of the given RangeSeekSlider
    private func getDict(fromRangeSeekSlider rangeSeekSlider: RangeSeekSlider) -> [String: Int] {
        let minValue = Int(rangeSeekSlider.selectedMinValue)
        let maxValue = Int(rangeSeekSlider.selectedMaxValue)

        let dict = [
            SettingsService.DictKey.minValue.rawValue: minValue,
            SettingsService.DictKey.maxValue.rawValue: maxValue
        ]

        return dict
    }

    ///Presents an alert with the given message
    private func presentAlert(message: String) {
        alertManager.presentErrorAlert(with: message, presentingViewController: self)
    }

}
