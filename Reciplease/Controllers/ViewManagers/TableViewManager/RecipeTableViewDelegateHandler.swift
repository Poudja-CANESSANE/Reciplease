//
//  RecipeTableViewDelegateHandler.swift
//  Reciplease
//
//  Created by Canessane Poudja on 02/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class RecipeTableViewDelegateHandler: NSObject, UITableViewDelegate {
    // MARK: - INTERNAL

    // MARK: Properties

    var didSelectRow: (IndexPath) -> Void



    // MARK: Inits

    init(didSelectRow: @escaping (IndexPath) -> Void) {
        self.didSelectRow = didSelectRow
    }



    // MARK: Methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(indexPath)
        
    }
}
