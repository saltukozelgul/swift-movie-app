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
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UITableView!
    private var refreshController = UIRefreshControl()
    
    override func viewWillAppear(_ animated: Bool) {
        // for prevent 2 times execution
        if !listedMovies.isEmpty {
            reloadTheMovies()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        reloadTheMovies()
    }
    
    func setupTableView() {
        tableView.refreshControl = self.refreshController
        tableView.registerNib(with: String(describing: MovieTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        refreshController.addTarget(self, action: #selector(reloadTheMovies), for: .valueChanged)
    }
    
    @objc func reloadTheMovies() {
        listedMovies.removeAll()
        FavouriteManager.shared.getFavouriteMovies { idList in
            self.favouriteMovies = idList.reduce(into: [:]) { (dict, id) in
                dict[id] = false
            }
            self.fetchFavouriteMovies()
        }
    }
    
    @objc func fetchFavouriteMovies() {
        // Get 10 id 10 from dict which is bool vlaue is false
        let moviesToFetch = Array(favouriteMovies.filter({ $0.value == false }).prefix(10))
        moviesToFetch.forEach { (id, _) in
            getMovieModel(movieId: id)
        }
    }

    func getMovieModel(movieId: Int) {
        // get movie by ID
        if let url = APIManager.shared.getMovieDetailUrl(movieId: movieId)  {
            NetworkManager.shared.fetchData(url: url) { (result: Result<Movie, AFError>) in
                switch result {
                    case .success(let movie):
                        self.listedMovies.append(movie)
                        self.favouriteMovies[movieId] = true
                        self.tableView.reloadData()
                    case .failure(let error):
                        ErrorAlertManager.shared.showAlert(title: NSLocalizedString("error", comment: "an error title"), message: error.localizedDescription, viewController: self)
                }
            }
        }
        refreshController.endRefreshing()
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = listedMovies[indexPath.row]
        navigateToMovieDetail(movie: movie)
    }
}



