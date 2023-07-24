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
        NetworkManager.shared.getPopularMovies(page: currentPage) { movies, maxPage in
            guard let movies else {
                return
            }
            if let maxPage {
                self.totalPages = maxPage
            }
            self.listedMovies.append(contentsOf: movies)
            self.tableView.reloadData()
        }
        currentPage += 1
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
}


