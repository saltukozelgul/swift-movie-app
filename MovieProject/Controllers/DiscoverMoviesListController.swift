//
//  DiscoverMovieListController.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 4.08.2023.
//

import UIKit
import Alamofire

class DiscoverMoviesListController: UIViewController {
    // Properties
    var genreString: String = ""
    var releaseDateGte: String = ""
    var releaseDateLte: String = ""
    var voteAverageGte: String = ""
    var voteAverageLte: String = ""
    var sortingTypeString: String = "" {
        didSet {
            switch sortingTypeString {
                case NSLocalizedString("releaseDateAsc", comment: ""):
                    sortingTypeEnum = .releaseDateAsc
                case NSLocalizedString("releaseDateDesc", comment: ""):
                    sortingTypeEnum = .releaseDateDesc
                case NSLocalizedString("voteAverageAsc", comment: ""):
                    sortingTypeEnum = .voteAverageAsc
                case NSLocalizedString("voteAverageDesc", comment: ""):
                    sortingTypeEnum = .voteAverageDesc
                case NSLocalizedString("popularityAsc", comment: ""):
                    sortingTypeEnum = .popularityAsc
                case NSLocalizedString("popularityDesc", comment: ""):
                    sortingTypeEnum = .popularityDesc
                case NSLocalizedString("voteCountAsc", comment: ""):
                    sortingTypeEnum = .voteCountAsc
                case NSLocalizedString("voteCountDesc", comment: ""):
                    sortingTypeEnum = .voteCountDesc
                default:
                    sortingTypeEnum = .popularityDesc
            }
            
        }
    }
    var sortingTypeEnum: MovieListSortingOptions!
    var movies: [Movie] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var totalPage = 1
    var currentPage = 1
    
    // IBOutlets
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            self.tableView.showLoading()
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.keyboardDismissMode = .onDrag
            self.tableView.registerNib(with: String(describing: MovieTableViewCell.self))
        }
    }
    
    // Life cylce methods
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovies()
    }
    
    // Custom methods
    func fetchMovies() {
        if let url = APIManager.shared.getDiscoverMoviesUrl(page: currentPage, genre: genreString, releaseDateGte: releaseDateGte, releaseDateLte: releaseDateLte, voteAverageGte: voteAverageGte, voteAverageLte: voteAverageLte, sorting: sortingTypeEnum) {
            NetworkManager.shared.fetchData(url: url) { [weak self] (result: Result<MovieSearchResult, AFError>) in
                guard let self = self else { return }
                switch result {
                    case .success(let movies):
                        self.movies.append(contentsOf: movies.results ?? [])
                        self.totalPage = movies.totalPages ?? 1
                        self.tableView.reloadData()
                        self.tableView.hideLoading()
                        self.currentPage += 1
                    case .failure(let error):
                        AlertManager.shared.showErrorAlert(title: NSLocalizedString("error", comment: "an error title"), message: error.localizedDescription, viewController: self)
                }
            }
        }
    }
}


extension DiscoverMoviesListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if movies.count == 0 {
            tableView.setEmptyView()
        } else {
            tableView.restore()
        }
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieTableViewCell.self), for: indexPath) as? MovieTableViewCell {
            cell.configureCellForDisplay(movie: movies[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
}

// MARK: - TableView Delegate

extension DiscoverMoviesListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 1 {
            if currentPage <= totalPage {
                fetchMovies()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableConstants.heightForPopularMovieRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        navigateToMovieDetail(movie: movie)
    }
}
