//
//  RoundedView.swift
//  Reciplease
//
//  Created by Canessane Poudja on 27/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class RoundedView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        addCornerRadius()
    }

    private func addCornerRadius() {
        layer.cornerRadius = 4
    }
}
