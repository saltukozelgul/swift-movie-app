//
//  ErrorAlertManager.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 26.07.2023.
//

import UIKit


class ErrorAlertManager {
    
    static let shared = ErrorAlertManager()
    
    private init() {}
    
    func showAlert(title: String, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: NSLocalizedString("ok", comment: "confirm text"), style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(okButton)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
}

