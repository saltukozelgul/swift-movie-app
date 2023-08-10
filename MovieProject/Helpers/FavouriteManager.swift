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
    private var entityName = Constants.entityNameForFavouriteCheck
    private var keyValue = Constants.keyValueForFavoriteCheck
    
    // This methods checks for movie if it is in favourites list or not.
    func isFavourite(movieId: Int?) -> Bool {
        guard let movieId else { return false }
        return CustomListManager.shared.checkMovieInCustomList(movieId: movieId, customListId: CustomListConstants.idForFavouritesList)
    }
    
    // This methods adds movie to favourites list.
    func addFavourite(movieId: Int?) -> Bool {
        guard let movieId else { return false }
        // Checks for a favourites list. If there is no favourites list, it creates one.
        if (!CustomListManager.shared.addMovieToCustomList(movieId: movieId, customListId: CustomListConstants.idForFavouritesList)) {
            CustomListManager.shared.createCustomList(listId: CustomListConstants.idForFavouritesList, listName: CustomListConstants.nameForFavouritesList) { result in
                if result != nil {
                    // Adds movie to favourites list.
                    CustomListManager.shared.addMovieToCustomList(movieId: movieId, customListId: CustomListConstants.idForFavouritesList)
                }
            }
        }
        return true
    }
    
    // This methods removes movie from favourites list.
    func removeFavourite(movieId: Int?) -> Bool {
        guard let movieId else { return false }
        return CustomListManager.shared.removeMovieFromCustomList(movieId: movieId, customListId: CustomListConstants.idForFavouritesList)
    }
    
    // This methods toggles movie's favourite status.
    func toggleFavourite(movieId: Int?, completion: (Bool, Bool) -> Void) {
        guard let movieId = movieId else {
            completion(false, false)
            return
        }
        if isFavourite(movieId: movieId) {
            let success = removeFavourite(movieId: movieId)
            completion(success, false)
        } else {
            let success = addFavourite(movieId: movieId)
            completion(success, true)
        }
    }
}

