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
    var willDisplayCell: (IndexPath) -> Void



    // MARK: Inits

    init(
        didSelectRow: @escaping (IndexPath) -> Void,
        willDisplayCell: @escaping (IndexPath) -> Void) {

        self.didSelectRow = didSelectRow
        self.willDisplayCell = willDisplayCell
    }



    // MARK: Methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        willDisplayCell(indexPath)
    }
}
