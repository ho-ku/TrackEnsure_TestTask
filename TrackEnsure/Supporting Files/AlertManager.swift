//
//  AlertManager.swift
//  TrackEnsure
//
//  Created by Денис Андриевский on 05.09.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit

final class AlertManager {
    
    // Sample OK Alert
    static func presentAlert(_ viewController: UIViewController, title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alertController, animated: true)
    }
    
}
