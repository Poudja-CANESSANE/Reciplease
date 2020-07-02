//
//  GradientView.swift
//  Reciplease
//
//  Created by Canessane Poudja on 02/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }

    @IBInspectable var secondColor: UIColor = UIColor.darkGray {
        didSet {
            updateView()
        }
    }

    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }


    private func updateView() {
        guard let layer = layer as? CAGradientLayer else { return }
        layer.colors = [firstColor.cgColor, secondColor.cgColor]
    }
}
