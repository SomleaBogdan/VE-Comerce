//
//  UIViewController+Extension.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import UIKit


extension UIViewController {
    func showErrorAlertWith(description: String?) {
        self.showAlertWith(title: "Error", description: description)
    }
    
    func showAlertWith(title: String, description: String?) {
        let alertController = UIAlertController(title: title,
                                                message: description,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
