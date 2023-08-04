//
//  FavouriteManager.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 23.07.2023.
//

import Foundation
import CoreData
import UIKit

class FavouriteManager {
    
    static let shared = FavouriteManager()
    private var context: NSManagedObjectContext?
    private var entityName = Constants.entityNameForFavouriteCheck
    private var keyValue = Constants.keyValueForFavoriteCheck
    
    
    private init() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.context = appDelegate.persistentContainer.viewContext
        }
    }
    
    func isFavourite(movieId: Int?) -> Bool {
        guard let movieId else { return false }
        if let _ = CustomListManager.shared.checkCustomList(customListId: CLConstants.idForFavouritesList) {
            return CustomListManager.shared.checkMovieInCustomList(movieId: movieId, customListId: CLConstants.idForFavouritesList)
        }
        return false
    }
    
    func addFavourite(movieId: Int?) -> Bool {
        guard let movieId else { return false }
        if let _ = CustomListManager.shared.checkCustomList(customListId: CLConstants.idForFavouritesList) {
            return CustomListManager.shared.addMovieToCustomList(movieId: movieId, customListId: CLConstants.idForFavouritesList)
            
        } else {
            CustomListManager.shared.createCustomList(listId: CLConstants.idForFavouritesList, listName: CLConstants.nameForFavouritesList) { result in
                if result != nil {
                    CustomListManager.shared.addMovieToCustomList(movieId: movieId, customListId: CLConstants.idForFavouritesList)
                }
            }
        }
        return true
    }
    
    func removeFavourite(movieId: Int?) -> Bool {
        guard let movieId else { return false }
        if let _ = CustomListManager.shared.checkCustomList(customListId: CLConstants.idForFavouritesList) {
            return CustomListManager.shared.removeMovieFromCustomList(movieId: movieId, customListId: CLConstants.idForFavouritesList)
        }
        return false
    }
    
    func toggleFavourite(movieId: Int?, completion: (Bool, Bool) -> Void) {
        if isFavourite(movieId: movieId) {
            return removeFavourite(movieId: movieId) ? completion(true, false) : completion(false, false)
        } else {
            return addFavourite(movieId: movieId) ? completion(true, true) : completion(false, false)
        }
    }
}

