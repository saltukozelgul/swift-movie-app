//
//  MovieDetailViewController.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 23.07.2023.
//

import UIKit
import FlagKit
import Alamofire



class MovieDetailViewController: UIViewController {

    // private tanımlamak daha mantıklı
    var movieId: Int?
    private(set) var detailedMovie: Movie?
    private(set) var castList: [Cast]?
    
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var moviePosterImageView: UIImageView!
    @IBOutlet private weak var voteAverageLabel: UILabel!
    @IBOutlet private weak var movieOverviewLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var budgetLabel: UILabel!
    @IBOutlet private weak var revenueLabel: UILabel!
    @IBOutlet private weak var runtimeLabel: UILabel!
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var gradientView: UIView!
    
    // CastCollectionView
    @IBOutlet private weak var castCollectionView: UICollectionView! {
        didSet {
            castCollectionView.delegate = self
            castCollectionView.dataSource = self
            castCollectionView.registerNib(with: String(describing: CastCollectionViewCell.self))
        }
    }
    // RecommendationView
    @IBOutlet private(set) weak var recommendationLabel: UILabel!
    @IBOutlet private weak var recommendationCollectionView: UICollectionView! {
        didSet {
            recommendationCollectionView.delegate = self
            recommendationCollectionView.dataSource = self
            recommendationCollectionView.registerNib(with: String(describing: RecommendedCollectionViewCell.self))
        }
    }
    @IBOutlet private weak var watchProvidersView: WatchProviderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.showLoading()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        setupNavbarButtons()
        fetchMovie()
    }

    func setupNavbarButtons() {
        let favouriteButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(favouriteButtonTapped))
        favouriteButton.tintColor = UIColor.systemPink
        self.navigationItem.rightBarButtonItem = favouriteButton
    }
    
    @objc func favouriteButtonTapped() {
        guard let movieId = movieId else { return }
        FavouriteManager.shared.toggleFavourite(movieId: movieId) { isSuccess, newState in
            if isSuccess {
                self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: newState ? Constants.iconNameForFavouriteMovie : Constants.iconNameForNotFavouriteMovie)
            }
        }
    }
    
    func fetchMovie() {
        if let movieId, let url = APIManager.shared.getMovieDetailUrl(movieId: movieId)  {
            NetworkManager.shared.fetchData(url: url) { (result: Result<Movie, AFError>) in
                switch result {
                    case .success(let movie):
                        self.detailedMovie = movie
                        self.updateUI()
                        self.view.hideLoading()
                    case .failure(let error):
                        ErrorAlertManager.shared.showAlert(title: NSLocalizedString("error", comment: "an error title"), message: error.localizedDescription, viewController: self)
                }
            }
            if let castUrl = APIManager.shared.getMovieCastUrl(movieId: movieId) {
                NetworkManager.shared.fetchData(url: castUrl) { (result: Result<MovieCredit, AFError>) in
                    switch result {
                        case .success(let credits):
                            self.castList = credits.cast
                            self.castCollectionView.reloadData()
                        case .failure(let error):
                            ErrorAlertManager.shared.showAlert(title: NSLocalizedString("error", comment: "an error title"), message: error.localizedDescription, viewController: self)
                    }
                }
            }
            
        }
    }
    
    func updateUI() {
        guard var detailedMovie = detailedMovie else { return }
        // If the movie has any recommendation set isHidden false for label
        if detailedMovie.recommendations?.results?.count ?? 0 > 0 {
            self.recommendationLabel.isHidden = false
        }
        
        // The movie is ready so we can update the recommendatations
        recommendationCollectionView.reloadData()
        
        // Add watchProviders if there is any
        self.watchProvidersView.addWatchProviderIcon(watchProviders: detailedMovie.watchProviders)
        
        // Smooth transiton between image and bottomView
        if let color = UIColor(named: "gradientBackground") {
            gradientView.setGradientBackground(colors: [color.withAlphaComponent(0.0).cgColor, color.cgColor])
        }
        
        // update navbar item if already favourited
        if FavouriteManager.shared.isFavourite(movieId: detailedMovie.id ?? 0) {
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: Constants.iconNameForFavouriteMovie)
        }
        
        // UI Labels
        movieNameLabel.text = (detailedMovie.originalTitle ?? "")
        movieOverviewLabel.text = detailedMovie.overview
        voteAverageLabel.text = String(detailedMovie.voteAverage?.rounded(toPlaces: 1) ?? 0) + " / 10"
        releaseDateLabel.text = detailedMovie.releaseDate?.getMonthAndYearWithLocale()
        genresLabel.text = detailedMovie.genres?.map { $0.name ?? "" }.joined(separator: ", ")
        moviePosterImageView.setImageFromPath(isOriginalSize: true, path: detailedMovie.backdropPath ?? "") { image in }
        budgetLabel.text = String(detailedMovie.budget ?? 0).convertToShortNumberFormat()
        revenueLabel.text = String(detailedMovie.revenue ?? 0).convertToShortNumberFormat()
        runtimeLabel.text = String(detailedMovie.runtime ?? 0) + NSLocalizedString("shortMin", comment: "that describes minutes")
    }

    
}


// MARK: CollectionView Methods

