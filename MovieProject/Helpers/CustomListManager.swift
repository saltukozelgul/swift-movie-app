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
    private var entityName = CLConstants.entityNameForCustomList
    
    private init () {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.context = appDelegate.persistentContainer.viewContext
        }
    }

    func checkCustomList(customListId: Int) -> CustomList? {
        guard let context else { return nil }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(CLConstants.keyValueForCustomListId) == %d", customListId)
        fetchRequest.fetchLimit = 1
        if let result = try? context.fetch(fetchRequest) {
            if let customList = result.first as? CustomList {
                return customList
            }
        }
        return nil
    }
    
    func checkMovieInCustomList(movieId: Int, customListId: Int) -> Bool {
        let customList = checkCustomList(customListId: customListId)
        if let customList {
            if let movies = customList.movies as? [Int] {
                if movies.contains(movieId) {
                    return true
                }
            }
            return false
        }
        return false
    }
    
    func addMovieToCustomList(movieId: Int, customListId: Int) -> Bool {
        guard let context else { return false }
        let customList = checkCustomList(customListId: customListId)
        if let customList {
            if var movies = customList.movies as? [Int] {
                if !movies.contains(movieId) {
                    customList.setValue(movies.append(movieId), forKey: CLConstants.keyValueForMovies)
                    do {
                        try context.save()
                        return true
                    } catch {
                        print("Error while saving custom list")
                        return false
                    }
                }
            }
        } else {
            return false
        }
    }
    
    func removeMovieFromCustomList(movieId: Int, customListId: Int) -> Bool {
        guard let context else { return false }
        let customList = checkCustomList(customListId: customListId)
        if let customList {
            if var movies = customList.movies as? [Int] {
                if movies.contains(movieId) {
                    movies.remove(at: movies.firstIndex(of: movieId)!)
                    customList.setValue(movies, forKey: CLConstants.keyValueForMovies)
                    do {
                        try context.save()
                        return true
                    } catch {
                        print("Error while saving custom list")
                        return false
                    }
                }
            }
        } else {
            return false
        }
    }
    
    func toggleMovieInCustomList(movieId: Int, customListId: Int, completion: @escaping (Bool) -> Void) {
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
    
    func getCustomListMovies(customListId: Int, completion: @escaping ([Int]) -> Void) {
        let customList = checkCustomList(customListId: customListId)
        if let customList {
            if let movies = customList.movies as? [Int] {
                return completion(movies)
            }
        }
        return completion([])
    }
    
    
    
    
}
