//
//  CustomListManager.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 2.08.2023.
//

import CoreData
import UIKit

class CustomListManager {
    
    static let shared = CustomListManager()
    private var context: NSManagedObjectContext?
    private var entityName = CustomListConstants.entityNameForCustomList
    
    private init () {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.context = appDelegate.persistentContainer.viewContext
        }
    }
    
    // This methods checks for custom lists and if there is returns it
    func checkCustomList(customListId: String) -> CustomList? {
        guard let context else { return nil }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(CustomListConstants.keyValueForCustomListId) == %@", customListId)
        fetchRequest.fetchLimit = 1
        if let result = try? context.fetch(fetchRequest) {
            if let customList = result.first as? CustomList {
                return customList
            }
        }
        return nil
    }
    
    // This methods checks for movie if it is in custom list
    func checkMovieInCustomList(movieId: Int, customListId: String) -> Bool {
        if let customList = checkCustomList(customListId: customListId), let movies = customList.movies {
            return movies.contains(movieId)
        }
        return false
    }
    
    // This methods add movie to custom lists that id has been given

   @discardableResult func addMovieToCustomList(movieId: Int, customListId: String) -> Bool {
        guard let context = context else { return false }
        if let customList = checkCustomList(customListId: customListId), var movies = customList.movies {
            if !movies.contains(movieId) {
                movies.append(movieId)
                customList.movies = movies
                return saveContext(context)
            }
        }
        return false
    }
    
    // This method removes from custom lists that id has been given
    func removeMovieFromCustomList(movieId: Int, customListId: String) -> Bool {
        guard let context = context else { return false }
        if let customList = checkCustomList(customListId: customListId), var movies = customList.movies {
            if let index = movies.firstIndex(of: movieId) {
                movies.remove(at: index)
                customList.movies = movies
                return saveContext(context)
            }
        }
        return false
    }
    
    // This methods toggles movie's custom list status
    func toggleMovieInCustomList(movieId: Int, customListId: String, completion: @escaping (Bool) -> Void) {
        if checkMovieInCustomList(movieId: movieId, customListId: customListId) {
            if removeMovieFromCustomList(movieId: movieId, customListId: customListId) {
                completion(false)
            } else {
                completion(true)
            }
        } else {
            if addMovieToCustomList(movieId: movieId, customListId: customListId) {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    // This methods is getting all the movie id that is in custom list
    func getCustomListMovies(customListId: String, completion: @escaping ([Int]) -> Void) {
        let customList = checkCustomList(customListId: customListId)
        if let customList {
            if let movies = customList.movies {
                return completion(movies)
            }
        }
        return completion([])
    }
    
    // This methods creates a custom list if ID has been given it uses that ID
    // if not it creates a new ID
    func createCustomList(listId: String = UUID().uuidString, listName: String, completion: @escaping (String?) -> Void) {
        guard let context else { return completion(nil) }
        if let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) {
            // Managed Object yaratıp oradan yürümek daha mantıklı olabilir.
            let newCustomList = NSManagedObject(entity: entity, insertInto: context)
            newCustomList.setValue(listName, forKey: CustomListConstants.keyValueForCustomListName)
            newCustomList.setValue(listId, forKey: CustomListConstants.keyValueForCustomListId)
            newCustomList.setValue([], forKey: CustomListConstants.keyValueForMovies)
            do {
                try context.save()
                completion(listId)
            } catch {
                print("Error while saving custom list")
                completion(nil)
            }
        }
    }
    
    func deleteCustomList(customListId: String, completion: @escaping (Bool) -> Void) {
        guard let context else { return completion(false) }
        if let customList = checkCustomList(customListId: customListId) {
            context.delete(customList)
            return completion(saveContext(context))
        }
        return completion(false)
    }
    
    
    func getAllCustomLists(completion: @escaping ([CustomList]) -> Void) {
        guard let context else { return completion([]) }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        if let result = try? context.fetch(fetchRequest) {
            if let customLists = result as? [CustomList] {
                return completion(customLists)
            }
        }
        return completion([])
    }
    
    func updateCustomList(customListId: String, customListName: String, completion: @escaping (Bool) -> Void) {
        guard let context else { return completion(false) }
        if let customList = checkCustomList(customListId: customListId) {
            customList.setValue(customListName, forKey: CustomListConstants.keyValueForCustomListName)
            return completion(saveContext(context))
        }
    }
    
    private func saveContext(_ context: NSManagedObjectContext) -> Bool {
        do {
            try context.save()
            return true
        } catch {
            print("Error while saving context: \(error)")
            return false
        }
    }
    
}
