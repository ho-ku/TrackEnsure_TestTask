//
//  EditStationVC.swift
//  TrackEnsure
//
//  Created by Денис Андриевский on 06.09.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit

final class EditStationVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var titleTextField: UITextField! {
        didSet {
            titleTextField.delegate = self
            titleTextField.tag = 1
        }
    }
    @IBOutlet private weak var providerTextField: UITextField! {
        didSet {
            providerTextField.delegate = self
            providerTextField.tag = 2
        }
    }
    @IBOutlet private weak var okBtn: UIButton!
    
    // MARK: - Properties
    var stationToEdit: GasStation!
    private let coredataManager = CoreDataManager()
    weak var delegate: ReturningToParentWithChangesDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    private func configureView() {
        okBtn.layer.cornerRadius = C.buttonCornerRadius
        titleTextField.placeholder = stationToEdit.title ?? ""
        providerTextField.placeholder = stationToEdit.fuelProvider ?? ""
    }
    
    private func configureSavingParameters() -> (String?, String?) {
        var parameters: (String?, String?) = (nil, nil)
        if let text = titleTextField.text, text != "", text != " " {
            parameters.0 = text
        }
        if let text = providerTextField.text, text != "", text != " " {
            parameters.1 = text
        }
        return parameters
    }

    @IBAction func okBtnPressed(_ sender: Any) {
        let parameters = configureSavingParameters()
        coredataManager.changeStationInfo(stationToEdit, newName: parameters.0, newProvider: parameters.1)
        FirebaseSynchronizer().saveChanges()
        delegate?.didFinishAddingStation()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension EditStationVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let nextTextField = view.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    
}
