//
//  UIViewcontroler+helper.swift
//  ApiManger
//
//  Created by Prashant Gajjar on 26/11/22.
//

import UIKit

extension UIViewController{
    func showAlert(title: String = "Api Manager",
                   _ msg: String?,
                   on viewController: UIViewController? = nil) {
        let ac = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
        ac.addAction(ok)
        if viewController != nil {
            viewController?.present(ac, animated: true, completion: nil)
        }
        else {
            Constant.appDelegate.window?.rootViewController?.present(ac, animated: true, completion: nil)
        }
    }
}
