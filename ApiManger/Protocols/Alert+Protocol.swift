//
//  Alert+Protocol.swift
//  ApiManger
//
//  Created by Prashant Gajjar on 26/04/23.
//

import UIKit

protocol AlertPresentable: UIViewController {
    
}

extension AlertPresentable {
    @MainActor
    func showAlert(
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style = .alert,
        buttons: UIAlertAction...
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        var buttons = buttons
        if buttons.isEmpty {
            let action = UIAlertAction(title: "Okay",
                                       style: .default)
            buttons.append(action)
        }
        buttons.forEach({alert.addAction($0)})

        self.present(alert, animated: true)
    }
}
