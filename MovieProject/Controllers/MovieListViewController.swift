//
//  ViewController.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 23.07.2023.
//

import UIKit

class MovieListViewController: UIViewController {
    var listedMovies = [Movie]()
    
    // Page variables
    var currentPage = 1
    var totalPages = 1
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: String(describing: MovieTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MovieTableViewCell.self))
        
        fetchData()
    }
    
    @objc func fetchData() {
        let url = NetworkConstants.popularMoviesUrl + "&page=\(currentPage)"
        NetworkManager.shared.fetchData(url: url) { (movies: PopularMovies?) in
            guard let movies = movies else {
                return
            }
            self.listedMovies.append(contentsOf: movies.results ?? [])
            self.totalPages = movies.totalPages ?? 1
            self.tableView.reloadData()
            self.currentPage += 1
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
        // deselect row again
        tableView.deselectRow(at: indexPath, animated: false)
    }
}


