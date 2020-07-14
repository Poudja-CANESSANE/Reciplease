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

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        displayFoodList()
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private var foods: [Food] {
        setSearchButtonState()
        return foodDataManager.getAll()
    }

    private let alertManager = ServiceContainer.alertManager
    private let foodDataManager = ServiceContainer.foodDataManager



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

    @IBAction func didTapSearchButton(_ sender: RoundedButton) {
        performSegue(withIdentifier: "recipeListSegue", sender: self)
    }


    // MARK: Methods

    private func clearFoods() {
        do {
            try foodDataManager.removeAll()
        } catch {
            presentAlert(message: "The deleting of the food list is impossible !")
        }
        displayFoodList()
    }

    private func displayFoodList() {
        var foodList = ""
        foods.forEach { if let name = $0.name { foodList += "- " + name + "\n" } }
        textView.text = foodList
    }

    private func addFood() {
        guard
            let foodName = textField.text,
            foodName != "",
            var foods = textView.text
            else { return }

        foods += "- " + foodName + "\n"
        textView.text = foods
        textField.text = ""

        do {
            try foodDataManager.save(name: foodName)
        } catch {
            presentAlert(message: "The saving of \(foodName) in Core Data is impossible !")
        }

        setSearchButtonState()
    }

    private func setSearchButtonState() {
        toggleSearchButtonEnableState(to: !foodDataManager.getAll().isEmpty)
    }

    private func toggleSearchButtonEnableState(to bool: Bool) {
        searchButton.isEnabled = bool
        searchButton.alpha = bool ? 1 : 0.5
    }

    private func presentAlert(message: String) {
        alertManager.presentErrorAlert(with: message, presentingViewController: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeListSegue" {
            //swiftlint:disable:next force_cast
            let recipeTableViewController = segue.destination as! RecipeTableViewController
            recipeTableViewController.foods = foods
        }
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
}
