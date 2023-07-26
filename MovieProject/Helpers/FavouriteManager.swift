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
    private var appDelegate: AppDelegate?
    private var context: NSManagedObjectContext?
    private var entityName = Constants.entityNameForFavouriteCheck
    private var keyValue = Constants.keyValueForFavoriteCheck
    
    
    private init() {
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.context = appDelegate?.persistentContainer.viewContext
    }
    
    func isFavourite(movieId: Int?) -> Bool {
        guard let context = context else { return false }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(keyValue) == %d", movieId ?? 0)
        fetchRequest.fetchLimit = 1
        guard let count = try? context.count(for: fetchRequest) else { return false }
        if count > 0 {
            return true
        }
        return false
    }
    
    func addFavourite(movieId: Int?) -> Bool {
        guard let context = context else { return false }
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        if let entity {
            let favouriteMovie = NSManagedObject(entity: entity, insertInto: context)
            favouriteMovie.setValue(movieId, forKey: "\(keyValue)")
            do {
                try context.save()
                return true
            } catch {
                print("Error while saving favourite movie")
                return false
            }
        }
        return false
    }
    
    func removeFavourite(movieId: Int?) -> Bool {
        guard let context = context else { return false }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(keyValue) == %d", movieId ?? 0)
        fetchRequest.fetchLimit = 1
        if let result = try? context.fetch(fetchRequest) {
            for object in result {
                context.delete(object as? NSManagedObject ?? NSManagedObject())
            }
        }
        do {
            try context.save()
            return true
        } catch {
            print("Error while saving favourite movie")
            return false
        }
        
    }
    
    func toggleFavourite(movieId: Int?, completion: (Bool, Bool) -> Void) {
        if isFavourite(movieId: movieId) {
            return removeFavourite(movieId: movieId) ? completion(true, false) : completion(false, false)
        } else {
            return addFavourite(movieId: movieId) ? completion(true, true) : completion(false, false)
        }
    }
}

