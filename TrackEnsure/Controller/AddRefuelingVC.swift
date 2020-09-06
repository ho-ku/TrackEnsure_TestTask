//
//  AddRefuelingVC.swift
//  TrackEnsure
//
//  Created by Денис Андриевский on 06.09.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit

final class AddRefuelingVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var fuelTypeField: UITextField! {
        didSet {
            fuelTypeField.delegate = self
            fuelTypeField.tag = 1
        }
    }
    @IBOutlet weak var amountField: UITextField! {
        didSet {
            amountField.delegate = self
            amountField.tag = 2
        }
    }
    @IBOutlet weak var costField: UITextField! {
        didSet {
            costField.delegate = self
            costField.tag = 3
        }
    }
    @IBOutlet weak var okBtn: UIButton!
    
    // MARK: - Properties
    var currentStation: GasStation!
    private let coredataManager = CoreDataManager()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    private func configureView() {
        okBtn.layer.cornerRadius = C.buttonCornerRadius
    }

    // MARK: - IBActions
    @IBAction func okBtnPressed(_ sender: Any) {
        guard let fuelType = fuelTypeField.text, fuelType != "", let amount = amountField.text, let doubleAmount = Double(amount), let cost = costField.text, let doubleCost = Double(cost) else { AlertManager.presentAlert(self, title: "Oops..", message: "Some of the fields are blank or contains inappropriate info"); return }
        coredataManager.addRefueling(to: currentStation, fuelType: fuelType, amount: doubleAmount, cost: doubleCost)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension AddRefuelingVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let nextField = view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        }
        return true
    }
}
