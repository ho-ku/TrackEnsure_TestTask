//
//  NewStationVC.swift
//  TrackEnsure
//
//  Created by Денис Андриевский on 05.09.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit

protocol ReturningToParentWithChangesDelegate: class {
    func didFinishAddingStation()
}

final class NewStationVC: UIViewController {

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
    @IBOutlet private weak var selectLocationBtn: UIButton!
    
    // MARK: - Properties
    private var selectedName: String = ""
    private var selectedProvider: String = ""
    weak var delegate: ReturningToParentWithChangesDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.didFinishAddingStation()
    }
    
    private func configureView() {
        selectLocationBtn.layer.cornerRadius = C.buttonCornerRadius
    }

    // MARK: - IBActions
    @IBAction private func selectLocationBtnPressed(_ sender: Any) {
        guard let name = titleTextField.text, name != "", let provider = providerTextField.text, provider != "" else { AlertManager.presentAlert(self, title: "Oops..", message: "Some of the fields are blank"); return }
        self.selectedName = name
        self.selectedProvider = provider
        performSegue(withIdentifier: C.selectLocationSegue, sender: self)
    }
    
    // MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == C.selectLocationSegue, let dest = segue.destination as? SelectLocationVC else { return }
        dest.selectedName = self.selectedName
        dest.selectedProvider = self.selectedProvider
        dest.newStationVC = self
    }
}

extension NewStationVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let nextTextField = view.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    
}
