//
//  SettingsViewController.swift
//  Reciplease
//
//  Created by Canessane Poudja on 04/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    // MARK: - INTERNAL

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setSwitchesActivation()
    }



    // MARK: - PRIVATE

    // MARK: IBOutlets

    @IBOutlet var switches: [UISwitch]!



    // MARK: IBActions

    @IBAction private func didSwitch(_ sender: UISwitch) {
        saveSetting(fromSender: sender)
    }



    // MARK: Properties

    private let alertManager = AlertManager()



    // MARK: Methods

    private func setSwitchesActivation() {
        switches.forEach {
            if let key = UserDefaultsKey(rawValue: $0.tag) {
                let isOn = UserDefaults.standard.bool(forKey: key.name)
                $0.isOn = isOn
            }
        }
    }

    private func saveSetting(fromSender sender: UISwitch) {
        guard let key = UserDefaultsKey(rawValue: sender.tag) else {
            presentAlert(message: "Cannot unwrap key to save your settings !")
            return
        }
        UserDefaults.standard.set(sender.isOn, forKey: key.name)
    }

    private func presentAlert(message: String) {
        alertManager.presentErrorAlert(with: message, presentingViewController: self)
    }

}
