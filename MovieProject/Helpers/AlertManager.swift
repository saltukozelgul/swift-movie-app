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
    
    func addMovieToCustomListAlert(viewController: UIViewController, movieId: Int, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: NSLocalizedString("addMovieToList", comment: "add movie title"), message: NSLocalizedString("addMovieToListMessage", comment: "add movie message"), preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: "cancel"), style: .cancel, handler: nil)
        // Get all custom lists and add an option for every one
        CustomListManager.shared.getAllCustomLists { customLists in
            // Remove the fav custom lists from this section and create new array
            let customLists = customLists.filter { $0.customListId != CLConstants.idForFavouritesList }
            for customList in customLists {
                switch CustomListManager.shared.checkMovieInCustomList(movieId: movieId, customListId: customList.customListId ?? "") {
                case true:
                    let action = UIAlertAction(title: customList.customListName, style: .destructive) { (action) in
                        CustomListManager.shared.removeMovieFromCustomList(movieId: movieId, customListId: customList.customListId ?? "")
                    }
                    alert.addAction(action)
                case false:
                    let action = UIAlertAction(title: customList.customListName, style: .default) { (action) in
                        CustomListManager.shared.addMovieToCustomList(movieId: movieId, customListId: customList.customListId ?? "")
                    }
                    alert.addAction(action)
                }          
            }
        }
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    
    func editCustomListAlert(viewController: UIViewController, customListId: String, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: NSLocalizedString("editList", comment: "edit list title"), message: NSLocalizedString("editListMessage", comment: "edit list message"), preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("editListPlaceholder", comment: "edit list placeholder")
        }
        let saveAction = UIAlertAction(title: NSLocalizedString("save", comment: "save"), style: .default) { (action) in
            if let listName = alert.textFields?.first?.text, !listName.isEmpty {
                CustomListManager.shared.updateCustomList(customListId: customListId, customListName: listName) { result in
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

