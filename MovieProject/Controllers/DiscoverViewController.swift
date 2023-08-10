//
//  DiscoverViewController.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 4.08.2023.
//

import UIKit
import Alamofire

class DiscoverViewController: UIViewController {
    // Properties
    var allGenres: [Genre]?
    var years: [String] = {
        var years: [String] = []
        let currentYear = Calendar.current.component(.year, from: Date())
        for year in 1870...currentYear {
            years.append(String(year))
        }
        return years
    }()
    var selectedGenres: [Genre] = [Genre(id: -1, name: NSLocalizedString("addGenre", comment: ""))]  {
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
    let rangeSlider = RangeSlider(frame: CGRect.zero)
    
    // IBOutlets and Actions
    @IBOutlet private weak var genresCollectionView: UICollectionView! {
        didSet {
            genresCollectionView.delegate = self
            genresCollectionView.dataSource = self
            genresCollectionView.registerNib(with: String(describing: GenreCollectionViewCell.self))
        }
    }
    @IBOutlet private weak var ratingSliderLowerLabel: UILabel!
    @IBOutlet private weak var ratingSliderUpperLabel: UILabel!
    @IBOutlet private weak var ratingSliderView: UIView! {
        didSet {
            ratingSliderView.addSubview(rangeSlider)
        }
    }
    @IBOutlet private weak var minumumDatePicker: UIPickerView! {
        didSet {
            minumumDatePicker.delegate = self
            minumumDatePicker.dataSource = self
            minumumDatePicker.selectRow(5, inComponent: 0, animated: false)
            
        }
    }
    @IBOutlet private weak var maximumDatePicker: UIPickerView! {
        didSet {
            maximumDatePicker.delegate = self
            maximumDatePicker.dataSource = self
            maximumDatePicker.selectRow(years.count - 3, inComponent: 0, animated: false)
        }
    }
    @IBOutlet private weak var sortingTypePicker: UIPickerView! {
        didSet {
            sortingTypePicker.delegate = self
            sortingTypePicker.dataSource = self
            sortingTypePicker.accessibilityIdentifier = "sorting"
            sortingTypePicker.selectRow(5, inComponent: 0, animated: false)
        }
    }
    
    @IBOutlet private weak var discoverButton: UIButton! {
        didSet {
            discoverButton.setCornerRadius(15)
        }
    }
    @IBAction func discoverButtonTapped(_ sender: Any) {
        let genreString = selectedGenres.map({ (genre) -> String in
            if genre.id != -1 {
                return String(genre.id ?? 0)
            }
            return ""
        }).joined(separator: ",")
        let releaseDateGte = years[minumumDatePicker.selectedRow(inComponent: 0)].toApiDateFormat()
        let releaseDateLte = years[maximumDatePicker.selectedRow(inComponent: 0)].toApiDateFormat()
        let voteAverageGte = ratingSliderLowerLabel.text ?? "0.0"
        let voteAverageLte = ratingSliderUpperLabel.text ?? "10.0"
        let sortingType = sortingTypes[sortingTypePicker.selectedRow(inComponent: 0)]
        self.navigateToDiscoverMovies(genre: genreString, releaseDateGte: releaseDateGte, releaseDateLte: releaseDateLte, voteAverageGte: voteAverageGte, voteAverageLte: voteAverageLte, sortingType: sortingType)
    }
    
    // Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGenres()
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged), for: .valueChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Margin is the margin of rootstackView
        let margin: CGFloat = 15
        // widthForText is the width of the labels
        let widthForText: CGFloat = 60
        // we subtract margins and labels from screen width
        let width = view.bounds.width - (2 * margin) - (2 * widthForText)
        rangeSlider.frame = CGRect(x: widthForText, y: 0, width: width, height: 30.0)
    }
    
    // Custom methods
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
    
    @objc func rangeSliderValueChanged() {
        let lowerValue = round(rangeSlider.lowerValue * 2) / 2
        let upperValue = round(rangeSlider.upperValue * 2) / 2
        ratingSliderLowerLabel.text = String(lowerValue)
        ratingSliderUpperLabel.text = String(upperValue)
    }
}

// MARK: Collectionv View Delegate Methods
extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (selectedGenres.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let genreCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GenreCollectionViewCell.self), for: indexPath) as? GenreCollectionViewCell {
            genreCell.configure(with: selectedGenres[indexPath.row])
            return genreCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // We have 10 margin from left and right so we subtract 20
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20 , height: TableConstants.heightForGenreCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            addGenreToCollectionView()
            return
        }
        removeGenreFromCollectionView(genre: selectedGenres[indexPath.row])
    }
    
    // This method will create an alert for adding genre
    func addGenreToCollectionView() {
        let alert = UIAlertController(title: NSLocalizedString("addGenre", comment: ""), message: NSLocalizedString("addGenreMessage", comment: ""), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        // creating an action for every genre for allGenres
        if let allGenres = self.allGenres {
            let unselectedGenrse = allGenres.filter { (genre) -> Bool in
                return !selectedGenres.contains(where: { $0.id == genre.id })
            }
            for genre in unselectedGenrse {
                let action = UIAlertAction(title: genre.name, style: .default) { (action) in
                    self.selectedGenres.append(genre)
                }
                alert.addAction(action)
            }
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func removeGenreFromCollectionView(genre: Genre) {
        self.selectedGenres = selectedGenres.filter { $0.id != genre.id }
    }
}

//MARK: PickerView Delagete Methods
extension DiscoverViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.accessibilityIdentifier == "sorting" ? sortingTypes.count : years.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // This method will return the title of the sorting type
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView.accessibilityIdentifier == "sorting" ? sortingTypes[row] : years[row]
    }
}
