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
    
    func checkMovieInCustomList(movieId: Int, customListId: String) -> Bool {
        if let customList = checkCustomList(customListId: customListId), let movies = customList.movies {
            return movies.contains(movieId)
        }
        return false
    }
    
    func addMovieToCustomList(movieId: Int, customListId: String) -> Bool {
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
    
    func getCustomListMovies(customListId: String, completion: @escaping ([Int]) -> Void) {
        let customList = checkCustomList(customListId: customListId)
        if let customList {
            if let movies = customList.movies {
                return completion(movies)
            }
        }
        return completion([])
    }
    
    func createCustomList(listId: String = UUID().uuidString, listName: String, completion: @escaping (String?) -> Void) {
        guard let context else { return completion(nil) }
        if let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) {
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
