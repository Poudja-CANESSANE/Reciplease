//swiftlint:disable statement_position
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
        return getFoods()
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

    @IBAction private func didTapSearchButton(_ sender: RoundedButton) {
        performSegue(withIdentifier: "recipeListSegue", sender: self)
    }

    @IBAction func dismissKeyboaed(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }

    // MARK: Methods

    ///Removes all Food from Core Data and clears textView
    private func clearFoods() {
        do { try foodDataManager.removeAll() }
        catch { presentAlert(message: CoreDataError.foodListDeletingIsImpossible.message) }
        displayFoodList()
    }

    ///Displays in textView all food saved in Core Data
    private func displayFoodList() {
        var foodList = ""
        foods.forEach { if let name = $0.name { foodList += "- " + name + "\n" } }
        textView.text = foodList
    }

    ///Appends the food entered in textField to textView and saves it in CoreData
    private func addFood() {
        guard
            let foodName = textField.text,
            foodName != "",
            var foods = textView.text
            else { return }

        foods += "- " + foodName + "\n"
        textView.text = foods
        textField.text = ""

        do { try foodDataManager.save(name: foodName) }
        catch { presentAlert(message: CoreDataError.foodSavingIsImpossible.message) }

        setSearchButtonState()
    }

    ///Sets the enable state and the alpha of searchButton to !foodDataManager.getAll().isEmpty
    private func setSearchButtonState() {
        let foods = getFoods()
        toggleSearchButtonEnableState(to: !foods.isEmpty)
    }

    private func getFoods() -> [Food] {
        var foods = [Food]()

        do { foods = try foodDataManager.getAll()
        } catch {
            presentAlert(message: (error as? CoreDataError)?.message ??
            "An error ocured while getting foods from CoreData !")
        }

        return foods
    }

    ///Sets the enable state and the alpha of searchButton to the given Bool
    private func toggleSearchButtonEnableState(to isEnable: Bool) {
        searchButton.isEnabled = isEnable
        searchButton.alpha = isEnable ? 1 : 0.5
    }

    ///Presents an alert with the given message
    private func presentAlert(message: String) {
        alertManager.presentErrorAlert(with: message, presentingViewController: self)
    }
}



// MARK: - Extension

// MARK: Keyboard

extension SearchViewController: UITextFieldDelegate {
    // MARK: - INTERNAL

    // MARK: Methods

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        addFood()
        return true
    }
}



// MARK: Navigation

extension SearchViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeListSegue" {
            //swiftlint:disable:next force_cast
            let recipeTableViewController = segue.destination as! RecipeTableViewController
            recipeTableViewController.foods = foods
        }
    }
}
