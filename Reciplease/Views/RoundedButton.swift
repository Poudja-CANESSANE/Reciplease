//
//  RoundedButton.swift
//  Reciplease
//
//  Created by Canessane Poudja on 25/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        addCornerRadius()
    }

    private func addCornerRadius() {
        layer.cornerRadius = 7
    }

}
