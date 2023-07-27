import UIKit
import Alamofire

class MovieListViewController: UIViewController {
    private var listedMovies = [Movie]()
    private var currentPage = 1
    private var totalPages = 1
    
    // Search variables
    private var searchPage = 1
    private var totalSearchPage = 1
    private var userIsSearching = false
    private var previousSearchQuery = ""
    private var searchTimer: Timer?
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchData()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNib(with: String(describing: MovieTableViewCell.self))
    }
    
    private func fetchData() {
        guard let url = APIManager.shared.getPopularMoviesUrl(page: currentPage) else { return }
        NetworkManager.shared.fetchData(url: url) { [weak self] (result: Result<PopularMovies, AFError>) in
            guard let self = self else { return }
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

// MARK: - TableView DataSource

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

// MARK: - TableView Delegate

extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == listedMovies.count - 1 {
            if userIsSearching {
                if searchPage <= totalSearchPage {
                    performSearch(previousSearchQuery, searchPage)
                }
            } else {
                if currentPage <= totalPages {
                    fetchData()
                }
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

// MARK: - Search Bar Delegate

extension MovieListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: Constants.searchTimerInterval, repeats: false, block: { [weak self] (_) in
            guard let self = self else { return }
            let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            self.clearTableAndSearchWithText(with: query)
        })
    }
    
    private func performSearch(_ query: String, _ searchPage: Int) {
        guard let url = APIManager.shared.getSearchUrl(query: query, page: searchPage) else { return }
        NetworkManager.shared.fetchData(url: url) { [weak self] (result: Result<PopularMovies, AFError>) in
            guard let self = self else { return }
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
    
    private func clearTableAndSearchWithText(with query: String) {
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
