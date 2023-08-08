//
//  MovieSearchViewController.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 23.07.2023.
//

import UIKit
import Alamofire

class CustomListViewController: UIViewController {
    // Properties
    var listId: String = ""
    var listName: String = "" {
        didSet {
            self.title = self.listName
        }
    }
    private var listedMovies = [Movie]()
    private var fetchStatus = [Int: Bool]()
    
    // IBOutlets
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.registerNib(with: String(describing: MovieTableViewCell.self))
            tableView.delegate = self
            tableView.dataSource = self
            tableView.keyboardDismissMode = .onDrag
        }
    }
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.registerNib(with: String(describing: MovieCollectionViewCell.self))
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    // Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        createSwapToGridButton()
        getCustomListMovies()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getCustomListMovies()
    }
    
    // Custom methods
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
    
    func createSwapToGridButton() {
        let swapToGridButton = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2"), style: .plain, target: self, action: #selector(swapToGridButtonTapped))
        self.navigationItem.rightBarButtonItem = swapToGridButton
    }
    
    @objc func swapToGridButtonTapped() {
        tableView.isHidden = !tableView.isHidden
        collectionView.isHidden = !collectionView.isHidden
        tableView.reloadData()
        collectionView.reloadData()
        self.navigationItem.rightBarButtonItem?.image = collectionView.isHidden ? UIImage(systemName: "square.grid.2x2") : UIImage(systemName: "list.dash")
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
        checkForLoadingStatus()
    }
    
    func checkForLoadingStatus() {
        if !fetchStatus.values.contains(false) {
            self.tableView.reloadData()
            self.collectionView.reloadData()
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
        if fetchStatus.isEmpty {
            tableView.setEmptyView(title: NSLocalizedString("emptyListTitle", comment: ""), message: NSLocalizedString("emptyListMessage", comment: ""), isCustomList: true)
        } else {
            tableView.restore()
        }
        return listedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieTableViewCell.self), for: indexPath) as! MovieTableViewCell
        let movie = listedMovies[indexPath.row]
        cell.configureCellForDisplay(movie: movie)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = listedMovies[indexPath.row]
        navigateToMovieDetail(movie: movie)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if fetchStatus.values.contains(false) {
            if indexPath.row == listedMovies.count - 1 {
                fetchCustomListMovies()
            }
        }
    }
}

//MARK: GridView Collection View Delagates
extension CustomListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listedMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieCollectionViewCell.self), for: indexPath) as! MovieCollectionViewCell
        let movie = listedMovies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = listedMovies[indexPath.row]
        navigateToMovieDetail(movie: movie)
    }
    
    // Set the sizes for cells 3 on 1 row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 30 - 20) / 3
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if fetchStatus.values.contains(false) {
            if indexPath.row == listedMovies.count - 1 {
                fetchCustomListMovies()
            }
        }
    }
}
