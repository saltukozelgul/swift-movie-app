//
//  FavoriteMoviesViewController.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 23.07.2023.
//

import UIKit
import Alamofire

class FavoriteMoviesViewController: UIViewController {
    private var listedMovies = [Movie]()
    private var favouriteMovies = [Int:Bool]()
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.refreshControl = self.refreshController
            tableView.registerNib(with: String(describing: MovieTableViewCell.self))
            tableView.delegate = self
            tableView.dataSource = self
            refreshController.addTarget(self, action: #selector(reloadTheMovies), for: .valueChanged)
        }
    }
    @IBOutlet private weak var searchBar: UITableView!
    private var refreshController = UIRefreshControl()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTheMovies()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @objc func reloadTheMovies() {
        FavouriteManager.shared.getFavouriteMovies { idList in
            self.favouriteMovies = idList.reduce(into: [:]) { (dict, id) in
                if self.favouriteMovies[id] == true {
                    dict[id] = true
                } else {
                    dict[id] = false
                }
            }
            // remove from listedMovies if the id is not in the idList
            self.listedMovies = self.listedMovies.filter({ idList.contains($0.id ?? 0) })
            // check for not fetched movies and fetch
            self.fetchFavouriteMovies()
        }
        refreshController.endRefreshing()
    }
    
    @objc func fetchFavouriteMovies() {
        // If the movie is not already fetched, we fetch it up to 10
        let moviesToFetch = Array(favouriteMovies.filter({ $0.value == false }).prefix(10))
        print("I will fetch \(moviesToFetch.count) movies")
        moviesToFetch.forEach { (id, _) in
            getMovieModel(movieId: id)
            // We set it true asap because of mutex, another request can come and this request should be perform
            // for this specific movie
            favouriteMovies[id] = true
        }
        // If even is there is no movie to fetch, we reload the tableview becuase user can unfav some movies
        tableView.reloadData()
    }

    func getMovieModel(movieId: Int) {
        // get movie by ID
        if let url = APIManager.shared.getMovieDetailUrl(movieId: movieId)  {
            NetworkManager.shared.fetchData(url: url) { (result: Result<Movie, AFError>) in
                switch result {
                    case .success(let movie):
                        self.listedMovies.append(movie)
                        self.tableView.reloadData()
                    case .failure(let error):
                        self.favouriteMovies[movieId] = false
                        ErrorAlertManager.shared.showAlert(title: NSLocalizedString("error", comment: "an error title"), message: error.localizedDescription, viewController: self)
                }
            }
        }
    }
    
}

// MARK: Table View Delegate

extension FavoriteMoviesViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listedMovies.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieTableViewCell.self), for: indexPath) as! MovieTableViewCell
        cell.configureCellForDisplay(movie: listedMovies[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.heightForPopularMovieRow
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == listedMovies.count - 1 && listedMovies.count < favouriteMovies.count  {
                fetchFavouriteMovies()
            }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = listedMovies[indexPath.row]
        navigateToMovieDetail(movie: movie)
    }
}



