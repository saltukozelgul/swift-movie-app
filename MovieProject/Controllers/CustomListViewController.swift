//
//  MovieSearchViewController.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 23.07.2023.
//

import UIKit
import Alamofire

class CustomListViewController: UIViewController {
    var listId: String = "" 
    var listName: String = "" {
        didSet {
            self.title = self.listName
        }
    }
    private var listedMovies = [Movie]()
    private var fetchStatus = [Int: Bool]()
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.registerNib(with: String(describing: MovieTableViewCell.self))
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        getCustomListMovies()
    }
    
    func getCustomListMovies() {
        CustomListManager.shared.getCustomListMovies(customListId: listId) { (movieIds) in
            print(movieIds)
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
    
    func fetchCustomListMovies() {
        // If the movie is not already fetched, we fetch it up to 10
        let moviesToFetch = Array(fetchStatus.filter({ $0.value == false }).prefix(10))
        print("I will fetch \(moviesToFetch.count) movies")
        moviesToFetch.forEach { (id, _) in
            fetchMovie(movieId: id)
            // We set it true asap because of mutex, another request can come and this request should be perform
            // for this specific movie
            fetchStatus[id] = true
        }
    }
    
    func fetchMovie(movieId: Int) {
        // get movie by ID
        if let url = APIManager.shared.getMovieDetailUrl(movieId: movieId)  {
            NetworkManager.shared.fetchData(url: url) { (result: Result<Movie, AFError>) in
                switch result {
                    case .success(let movie):
                        self.listedMovies.append(movie)
                        self.tableView.reloadData()
                    case .failure(let error):
                        self.fetchStatus[movieId] = false
                        AlertManager.shared.showErrorAlert(title: NSLocalizedString("error", comment: "an error title"), message: error.localizedDescription, viewController: self)
                }
            }
        }
    }
}

extension CustomListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieTableViewCell.self), for: indexPath) as! MovieTableViewCell
        let movie = listedMovies[indexPath.row]
        cell.configureCellForDisplay(movie: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = listedMovies[indexPath.row]
        navigateToMovieDetail(movie: movie)
    }
}

