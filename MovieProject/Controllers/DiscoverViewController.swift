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
    @IBOutlet private weak var sortingTypePicker: UIPickerView! {
        didSet {
            sortingTypePicker.delegate = self
            sortingTypePicker.dataSource = self
            sortingTypePicker.selectRow(5, inComponent: 0, animated: false)
        }
    }
    @IBAction func minumumRatingStepperTapped(_ sender: Any) {
        minumumRatingLabel.text = String(minimumRatingStepper.value / 2.0)
    }
    @IBAction func maximumRatingStepperTapped(_ sender: Any) {
        maximumRatingLabel.text = String(maximumRatingStepper.value / 2.0)
    }
    @IBAction func addNewGenreButtonTapped(_ sender: Any) {
        addGenreToCollectionView()
    }
    
    @objc func discoverButtonTapped() {
        let genreString = selectedGenres?.map({ (genre) -> String in
            return String(genre.id ?? 0)
        }).joined(separator: ",") ?? ""
        let releaseDateGte = minumumDatePicker.date.convertToApiFormat()
        let releaseDateLte = maximumDatePicker.date.convertToApiFormat()
        let voteAverageGte = String(minimumRatingStepper.value / 2.0)
        let voteAverageLte = String(maximumRatingStepper.value / 2.0)
        let sortingType = sortingTypes[sortingTypePicker.selectedRow(inComponent: 0)]
        self.navigateToDiscoverMovies(genre: genreString, releaseDateGte: releaseDateGte, releaseDateLte: releaseDateLte, voteAverageGte: voteAverageGte, voteAverageLte: voteAverageLte, sortingType: sortingType)
    }
    
    // Variables
    var allGenres: [Genre]?
    var selectedGenres: [Genre]? {
        didSet {
            genresCollectionView.reloadData()
        }
    }
    let sortingTypes = [
        NSLocalizedString("releaseDateAsc", comment: ""),
        NSLocalizedString("releaseDateDesc", comment: ""),
        NSLocalizedString("voteAverageAsc", comment: ""),
        NSLocalizedString("voteAverageDesc", comment: ""),
        NSLocalizedString("popularityAsc", comment: ""),
        NSLocalizedString("popularityDesc", comment: ""),
        NSLocalizedString("voteCountAsc", comment: ""),
        NSLocalizedString("voteCountDesc", comment: "")
    ]
    
    // Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add navbar button that writes discover on it with search icon
        createNavbarItem()
        fetchGenres()
    }
    
    func createNavbarItem() {
        let discoverButton = UIBarButtonItem(title: NSLocalizedString("discover", comment: ""), style: .plain, target: self, action: #selector(discoverButtonTapped))
        discoverButton.image = UIImage(systemName: "magnifyingglass")
        navigationItem.rightBarButtonItem = discoverButton
        
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

// MARK: Collectionv View Delegate Methods
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
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func removeGenreFromCollectionView(genre: Genre) {
        if let selectedGenres = self.selectedGenres {
            self.selectedGenres = selectedGenres.filter { $0.id != genre.id }
        }
    }
}

//MARK: PickerView Delagete Methods
extension DiscoverViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortingTypes.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // This method will return the title of the sorting type
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortingTypes[row]
    }
}
