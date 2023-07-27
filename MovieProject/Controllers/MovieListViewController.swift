//
//  ViewController.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 23.07.2023.
//

import UIKit
import Alamofire

class MovieListViewController: UIViewController {
    private var listedMovies = [Movie]()
    
    // Page variables
    private var currentPage = 1
    private var totalPages = 1
    
    // Search Page Variables
    private var searchPage = 1
    private var totalSearchPage = 1
    private var userIsSearching = false
    private var previousSearchQuery = ""
    
    // Timer for search
    private var searchTimer: Timer?
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNib(with: String(describing: MovieTableViewCell.self))
        fetchData()
    }
    
    func fetchData() {
        if let url = APIManager.shared.getPopularMoviesUrl(page: currentPage) {
            NetworkManager.shared.fetchData(url: url) { (result: Result<PopularMovies, AFError>) in
                switch result {
                    case .success(let movies):
                        self.listedMovies.append(contentsOf: movies.results ?? [])
                        self.totalPages = movies.totalPages ?? 1
                        self.tableView.reloadData()
                        self.currentPage += 1
                    case .failure(let error):
                        ErrorAlertManager.shared.showAlert(title: NSLocalizedString("error", comment: "an error title"), message: error.localizedDescription, viewController: self)
                }
            }
        }
    }
}

// MARK: TableView Methods

extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieTableViewCell.self), for: indexPath) as! MovieTableViewCell
        cell.configureCellForDisplay(movie: listedMovies[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
}

extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == listedMovies.count - 1 {
            if userIsSearching {
                if searchPage <= totalSearchPage {
                    performSearch(previousSearchQuery, searchPage)
                }
                return
            }
            if currentPage <= totalPages {
                fetchData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.heightForPopularMovieRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = listedMovies[indexPath.row]
        navigateToMovieDetail(movie: movie)
    }
}

// MARK: Search Bar Methods

extension MovieListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: Constants.searchTimerInterval, repeats: false, block: { (_) in
            let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            self.clearTableAndSearchWithText(with: query)
        })
    }
    
    func performSearch(_ query: String, _ searchPage: Int) {
        if let url = APIManager.shared.getSearchUrl(query: query, page: searchPage) {
            NetworkManager.shared.fetchData(url: url) { (result: Result<PopularMovies, AFError>) in
                switch result {
                    case .success(let response):
                        self.listedMovies.append(contentsOf: response.results ?? [])
                        self.totalSearchPage = response.totalPages ?? 1
                        self.tableView.reloadData()
                        self.searchPage += 1
                    case .failure(let error):
                        ErrorAlertManager.shared.showAlert(title: NSLocalizedString("error", comment: "an error title"), message: error.localizedDescription, viewController: self)
                }
            }
        }
    }
    
    func clearTableAndSearchWithText(with query: String) {
        if query.isEmpty {
            clearTableAndFetchPopularMovies()
        } else {
            performSearchAndUpdateResults(with: query)
        }
    }
    
    private func clearTableAndFetchPopularMovies() {
        userIsSearching = false
        listedMovies.removeAll()
        currentPage = 1
        totalPages = 1
        fetchData()
    }
    
    private func performSearchAndUpdateResults(with query: String) {
        if query != previousSearchQuery {
            userIsSearching = true
            cancelPreviousSearchRequests()
            previousSearchQuery = query
            listedMovies.removeAll()
            searchPage = 1
            totalSearchPage = 1
        }
        performSearch(query, searchPage)
    }
    
    private func cancelPreviousSearchRequests() {
        AF.withAllRequests { requests in
            requests.forEach { request in
                if request.request?.url?.absoluteString.contains("search") ?? false {
                    request.cancel()
                }
            }
        }
    }
}


