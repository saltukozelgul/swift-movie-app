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
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNib(with: String(describing: MovieTableViewCell.self))
        fetchData()
    }
    
    @objc func fetchData() {
        let url = NetworkUrlBuilder.getPopularMoviesUrl(page: currentPage)
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


