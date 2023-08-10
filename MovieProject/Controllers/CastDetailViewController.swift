//
//  CastDetailViewController.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 23.07.2023.
//

import UIKit
import Alamofire

class CastDetailViewController: UIViewController {
    // Properties
    var personId: Int?
    private var detailedCast: Cast?
    var delegate: ViewControllerNavigationHandlerDelegate?
    
    // IBOutlets
    @IBOutlet private weak var castImageView: UIImageView!
    @IBOutlet private weak var placeOfBirthLabel: UILabel!
    @IBOutlet private weak var deathdayHeaderLabel: UILabel!
    @IBOutlet private weak var deathdayLabel: UILabel!
    @IBOutlet private weak var birthdayLabel: UILabel!
    @IBOutlet private weak var bioLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var moviesCollectionView: UICollectionView! {
        didSet {
            moviesCollectionView.delegate = self
            moviesCollectionView.dataSource = self
            moviesCollectionView.registerNib(with: String(describing: RecommendedCollectionViewCell.self))
        }
    }
    @IBOutlet weak var bottomCardView: UIView! {
        didSet {
            bottomCardView.setCornerRadius(30)
        }
    }
    
    // Life cylce methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.showLoading()
        fetchPerson()
    }
    
    // custom methods
    func fetchPerson() {
        if let personId, let url = APIManager.shared.getPersonDetailUrl(personId: personId)   {
            NetworkManager.shared.fetchData(url: url) { (result: Result<Cast, AFError>) in
                switch result {
                    case .success(let person):
                        self.detailedCast = person
                        self.updateUI()
                        self.view.hideLoading()
                    case .failure(let error):
                        AlertManager.shared.showErrorAlert(title: NSLocalizedString("error", comment: "an error title"), message: error.localizedDescription, viewController: self)
                }
            }
        }
    }
    
    func updateUI() {
        if let person = detailedCast {
            nameLabel.text = person.name
            bioLabel.text = person.biography
            birthdayLabel.text = person.birthday?.getFullDateWithLocale()
            if let deathday = person.deathday {
                deathdayLabel.text = deathday.getFullDateWithLocale()
            } else {
                deathdayHeaderLabel.isHidden = true
                deathdayLabel.isHidden = true
            }
            placeOfBirthLabel.text = person.placeOfBirth
            if let profilePath = person.profilePath {
                castImageView.setImageFromPath(path: profilePath) { image in
                    return
                }
            }
            moviesCollectionView.reloadData()
        }
    }
}


extension CastDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailedCast?.movieCredits?.cast?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RecommendedCollectionViewCell.self), for: indexPath) as? RecommendedCollectionViewCell {
            if let movie = detailedCast?.movieCredits?.cast?[indexPath.row] {
                cell.configure(movie)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movie = self.detailedCast?.movieCredits?.cast?[indexPath.row]  {
            delegate?.dismissAndNavigateToMovieDetail(movie: movie)
        }
    }
}

