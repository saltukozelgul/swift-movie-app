//
//  DiscoverViewController.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 4.08.2023.
//

import UIKit
import Alamofire

class DiscoverViewController: UIViewController {
    
    //IBOutlets and Actions
    @IBOutlet private weak var genresCollectionView: UICollectionView! {
        didSet {
            genresCollectionView.delegate = self
            genresCollectionView.dataSource = self
            genresCollectionView.registerNib(with: String(describing: GenreCollectionViewCell.self))
        }
    }
    @IBOutlet private weak var minumumRatingLabel: UILabel!
    @IBOutlet private weak var minimumRatingStepper: UIStepper!
    @IBOutlet private weak var maximumRatingLabel: UILabel!
    @IBOutlet private weak var maximumRatingStepper: UIStepper!
    @IBOutlet private weak var minumumDatePicker: UIDatePicker!
    @IBOutlet private weak var maximumDatePicker: UIDatePicker!
    @IBAction func minumumRatingStepperTapped(_ sender: Any) {
        minumumRatingLabel.text = String(minimumRatingStepper.value / 2.0)
    }
    @IBAction func maximumRatingStepperTapped(_ sender: Any) {
        maximumRatingLabel.text = String(maximumRatingStepper.value / 2.0)
    }
    
    @IBAction func addNewGenreButtonTapped(_ sender: Any) {
        addGenreToCollectionView()
    }
    
    @IBAction func discoverButtonTapped(_ sender: Any) {
        let genreString = selectedGenres?.map({ (genre) -> String in
            return String(genre.id ?? 0)
        }).joined(separator: ",") ?? ""
        let releaseDateGte = minumumDatePicker.date.convertToApiFormat()
        let releaseDateLte = maximumDatePicker.date.convertToApiFormat()
        let voteAverageGte = String(minimumRatingStepper.value / 2.0)
        let voteAverageLte = String(maximumRatingStepper.value / 2.0)
        

        if let url = APIManager.shared.getDiscoverMoviesUrl(page: currentPage, genre: genreString, releaseDateGte: releaseDateGte, releaseDateLte: releaseDateLte, voteAverageGte: voteAverageGte, voteAverageLte: voteAverageLte) {
            // Will be implemented for navigate a new list screen
        }
    }
    
    // Variables
    var allGenres: [Genre]?
    var selectedGenres: [Genre]? {
        didSet {
            genresCollectionView.reloadData()
        }
    }
    var currentPage = 1
    var totalPage = 1
    
    // Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGenres()
    }
    
    // Extra methods
    func fetchGenres() {
        if let url = APIManager.shared.getGenreUrl() {
            NetworkManager.shared.fetchData(url: url) { (result: Result<GenreList, AFError>) in
                switch result {
                    case .success(let genres):
                        self.allGenres = genres.genres
                    case .failure(let error):
                        AlertManager.shared.showErrorAlert(title: NSLocalizedString("error", comment: "an error title"), message: error.localizedDescription, viewController: self)
                }
            }
        }
    }
}


extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedGenres?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let genreCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GenreCollectionViewCell.self), for: indexPath) as? GenreCollectionViewCell {
            genreCell.configure(with: selectedGenres?[indexPath.row])
            return genreCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20 , height: TableConstants.heightForGenreCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedGenres = self.selectedGenres {
            removeGenreFromCollectionView(genre: selectedGenres[indexPath.row])
        }
    }
    
    // This method will create an alert for adding genre
    func addGenreToCollectionView() {
        let alert = UIAlertController(title: NSLocalizedString("addGenre", comment: ""), message: NSLocalizedString("addGenreMessage", comment: ""), preferredStyle: .alert)
        // create an action for every genre for allGenres
        if let allGenres = self.allGenres {
            let unselectedGenrse = allGenres.filter { (genre) -> Bool in
                if let selectedGenres = self.selectedGenres {
                    return !selectedGenres.contains(where: { $0.id == genre.id })
                }
                return true
            }
            for genre in unselectedGenrse {
                let action = UIAlertAction(title: genre.name, style: .default) { (action) in
                    if self.selectedGenres != nil {
                        self.selectedGenres?.append(genre)
                    }
                    else {
                        self.selectedGenres = [genre]
                    }
                }
                alert.addAction(action)
            }
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func removeGenreFromCollectionView(genre: Genre) {
        if let selectedGenres = self.selectedGenres {
            self.selectedGenres = selectedGenres.filter { $0.id != genre.id }
        }
    }
}
