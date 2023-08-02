//
//  ErrorAlertManager.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 26.07.2023.
//

import UIKit


class AlertManager {
    
    static let shared = AlertManager()
    
    private init() {}
    
    func showErrorAlert(title: String, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: NSLocalizedString("ok", comment: "confirm text"), style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(okButton)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func showNewCustomListAlert(viewController: UIViewController, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: NSLocalizedString("newList", comment: "new list title"), message: NSLocalizedString("newListMessage", comment: "new list message"), preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("newListPlaceholder", comment: "list name")
        }
        let saveAction = UIAlertAction(title: NSLocalizedString("save", comment: "save"), style: .default) { (action) in
            if let listName = alert.textFields?.first?.text, !listName.isEmpty {
                CustomListManager.shared.createCustomList(listName: listName) { result in
                    return completion(result)
                }
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: "cancel"), style: .cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    
}

