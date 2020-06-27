//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Canessane Poudja on 22/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: - INTERNAL

    // MARK: Lifecycle metods

    override func viewDidLoad() {
        super.viewDidLoad()
        displayFoodList()
    }



    // MARK: - PRIVATE

    // MARK: Properties
    private var foods: [Food] {
        Food.all
    }



    // MARK: IBOutlets

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var addButton: RoundedButton!
    @IBOutlet private weak var clearButton: RoundedButton!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var searchButton: RoundedButton!



    // MARK: IBActions

    @IBAction private func didTapAddButton(_ sender: RoundedButton) {
        addFood()
    }

    @IBAction private func didTapClearButton(_ sender: RoundedButton) {
        clearFoods()
    }
    @IBAction private func didTapSearchButton(_ sender: RoundedButton) {
        performSegue(withIdentifier: "recipeListSegue", sender: self)
    }



    // MARK: Methods

    private func clearFoods() {
        Food.removeFoods()
        displayFoodList()
    }

    private func displayFoodList() {
        var foodList = ""

        foods.forEach {
            if let name = $0.name {
                foodList += "- " + name + "\n"
            }
        }

        textView.text = foodList
    }

    private func presentErrorAlert(message: String) {
        let alertController = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)

        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

extension SearchViewController: UITextFieldDelegate {
    // MARK: - INTERNAL

    // MARK: Methods

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        addFood()
        return true
    }



    // MARK: - PRIVATE

    // MARK: Methods

    private func addFood() {
        print(foods)
        guard let foodName = textField.text, var foods = textView.text else { return }
        foods += "- " + foodName + "\n"
        textView.text = foods
        textField.text = ""

        Food.saveFood(named: foodName)
    }
}
