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

    private func setSwitchesActivation() {
        switches.forEach {
            if let key = SettingsService.Key(rawValue: $0.tag) {
                let isOn = settingsService.getIsOn(forKey: key)
                $0.isOn = isOn
            }
        }
    }

    private func setRangeSeekSlidersValues() {
        rangeSeekSliders.forEach {
            if let key = SettingsService.Key(rawValue: $0.tag) {
                $0.selectedMinValue = CGFloat(settingsService.getMinValue(forKey: key))
                $0.selectedMaxValue = CGFloat(settingsService.getMaxValue(forKey: key))
            }
        }
    }

    private func saveSwitchSetting(fromSender sender: UISwitch) {
        guard let key = getKey(fromSender: sender) else { return }
        settingsService.setIsOn(to: sender.isOn, forKey: key)
    }

    private func saveSlidersSettings() {
        rangeSeekSliders.forEach { saveRangeSeekSliderSetting(fromSender: $0) }
    }

    private func saveRangeSeekSliderSetting(fromSender sender: RangeSeekSlider) {
        guard let key = getKey(fromSender: sender) else { return }
        let dict = getDict(fromRangeSeekSlider: sender)
        ServiceContainer.settingsService.setMinAndMaxValues(to: dict, forKey: key)
    }

    private func getKey(fromSender sender: UIControl) -> SettingsService.Key? {
        guard let key = SettingsService.Key(rawValue: sender.tag) else {
            presentAlert(message: CustomError.cannotUnwrapKey.message)
            return nil
        }
        return key
    }

    private func getDict(fromRangeSeekSlider rangeSeekSlider: RangeSeekSlider) -> [String: Int] {
        let minValue = Int(rangeSeekSlider.selectedMinValue)
        let maxValue = Int(rangeSeekSlider.selectedMaxValue)

        let dict = [
            SettingsService.DictKey.minValue.rawValue: minValue,
            SettingsService.DictKey.maxValue.rawValue: maxValue
        ]

        return dict
    }

    private func presentAlert(message: String) {
        alertManager.presentErrorAlert(with: message, presentingViewController: self)
    }

}
