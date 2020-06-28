//
//  OutlinedLabel.swift
//  Reciplease
//
//  Created by Canessane Poudja on 28/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class OutlinedLabel: UILabel {

    var outlineWidth: CGFloat = 3
    var outlineColor: UIColor = UIColor.black
    var foregroundColor: UIColor = UIColor.white

    override func drawText(in rect: CGRect) {

        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: outlineColor,
            .foregroundColor: foregroundColor,
            .strokeWidth: -1 * outlineWidth
            ]

        self.attributedText = NSAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
        super.drawText(in: rect)
    }
}
