//
//  AddIngredientTableViewCell.swift
//  Reciplease
//
//  Created by Canessane Poudja on 25/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class AddIngredientTableViewCell: UITableViewCell {
    var ingredient = ""
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var addButton: UIButton!

    @IBAction private func didTapAddButton(_ sender: UIButton) {
        guard let ingredient = textField.text else { return }
        self.ingredient = ingredient
    }


}
