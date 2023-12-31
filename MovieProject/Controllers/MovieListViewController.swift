import UIKit
import Alamofire

class MovieListViewController: UIViewController {
    // Popular list variables
    private var listedMovies = [Movie]()
    private var searchedMovies = [Movie]()
    private var currentPage = 1
    private var totalPages = 1
    private var lastPreservedRow = 0
    
    // Search variables
    private var searchPage = 1
    private var totalSearchPage = 1
    private var userIsSearching = false
    private var previousSearchQuery = ""
    private var searchTimer: Timer?
    
    // IBOutlets
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.keyboardDismissMode = .onDrag
            tableView.registerNib(with: MovieTableViewCell.self)
        }
    }
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // Life cycle methods
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    // Custom methods
    private func fetchData() {
        // TODO: Bir movieservice katmanı yazılıp, o servis burada tüketilebir.
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
                    AlertManager.shared.showErrorAlert(title: NSLocalizedString("error", comment: "an error title"), message: error.localizedDescription, viewController: self)
            }
        }
    }
}

// MARK: - TableView DataSource

extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userIsSearching ? searchedMovies.count : listedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieTableViewCell.self), for: indexPath) as? MovieTableViewCell {
            cell.configureCellForDisplay(movie: userIsSearching ? searchedMovies[indexPath.row] : listedMovies[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - TableView Delegate

extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == listedMovies.count - 1 {
            if userIsSearching {
                if searchPage <= totalSearchPage {
                    performSearch(previousSearchQuery)
                }
            } else {
                if currentPage <= totalPages {
                    fetchData()
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableConstants.heightForPopularMovieRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = userIsSearching ? searchedMovies[indexPath.row] : listedMovies[indexPath.row]
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    private func performSearch(_ query: String) {
        // If the search query is new so the first search attempt
        if query != previousSearchQuery {
            self.userIsSearching = true
            self.cancelPreviousSearchRequests()
            self.searchedMovies.removeAll()
            self.searchPage = 1
            self.totalSearchPage = 1
        }
        guard let url = APIManager.shared.getSearchUrl(query: query, page: self.searchPage) else { return }
        NetworkManager.shared.fetchData(url: url) { [weak self] (result: Result<MovieSearchResult, AFError>) in
            guard let self = self else { return }
            switch result {
                case .success(let response):
                    // If the search is new we have to update query and scroll to top
                    if (query != self.previousSearchQuery) {
                        self.previousSearchQuery = query
                        if self.tableView.numberOfRows(inSection: 0) > 0 {
                            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                        }
                    }
                    self.searchedMovies.append(contentsOf: response.results ?? [])
                    self.totalSearchPage = response.totalPages ?? 1
                    self.tableView.reloadData()
                    self.searchPage += 1
                case .failure(let error):
                    AlertManager.shared.showErrorAlert(title: NSLocalizedString("error", comment: "an error title"), message: error.localizedDescription, viewController: self)
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
        // When user delete the search bar we have to scroll previous last visible row
        userIsSearching = false
        previousSearchQuery = ""
        tableView.reloadData()
        // Scroll to last position on popular list
        tableView.scrollToRow(at: IndexPath(row: lastPreservedRow, section: 0), at: .bottom, animated: false)
    }
    
    private func performSearchAndUpdateResults(with query: String) {
        if (!userIsSearching) {
            lastPreservedRow = tableView.indexPathsForVisibleRows?.last?.row ?? 0
        }
        performSearch(query)
    }
    
    // Bunu network katmanına almak çok daha mnatıklı
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
