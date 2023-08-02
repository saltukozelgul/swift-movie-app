//
//  MovieSearchViewController.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 23.07.2023.
//

import UIKit

class CustomListViewController: UIViewController {
    let listId: Int
    let listName: String
    private var listedMovies = [Movie]()
    private var fetchStatus = [Int: Bool]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init (listId: Int, listName: String) {
        self.listId = listId
        self.listName = listName
        super.init(nibName: nil, bundle: nil)
        self.title = self.listName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchCustomListMovies() {
        CustomListManager.shared.getCustomListMovies(customListId: listId) { (movieIds) in
            self.fetchStatus = movieIds.reduce(into: [:]) { (dict, id) in
                if self.fetchStatus[id] == true {
                    dict[id] = true
                } else {
                    dict[id] = false
                }
            }
            // remove from listedMovies if the id is not in the idList
            self.listedMovies = self.listedMovies.filter({ movieIds.contains($0.id ?? 0) })
            // check for not fetched movies and fetch
            self.fetchCustomListMovies()
        }
    }
    
    
}
