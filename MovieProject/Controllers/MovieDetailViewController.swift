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
    private(set) var detailedMovie: Movie? {
        didSet {
            recommendationCollectionView.reloadData()
        }
    }
    private(set) var castList: [Cast]?
    
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var moviePosterImageView: UIImageView! {
        didSet {
            moviePosterImageView.showLoading()
        }
    }
    @IBOutlet private weak var voteAverageLabel: UILabel!
    @IBOutlet private weak var movieOverviewLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var genresStackView: UIStackView!
    @IBOutlet private weak var budgetLabel: UILabel!
    @IBOutlet private weak var revenueLabel: UILabel!
    @IBOutlet private weak var runtimeLabel: UILabel!
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var flagLabel: UILabel!
    @IBOutlet private weak var bottomStackView: UIStackView!
    @IBOutlet private weak var gradientView: UIView! {
        didSet {
            if let color = UIColor(named: "gradientBackground") {
                gradientView.setGradientBackground(colors: [color.withAlphaComponent(0.0).cgColor, color.cgColor])
            }
        }
    }
    
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

    @IBOutlet weak var trailerButton: UIImageView! {
        didSet {
            // add tapture gesture
            trailerButton.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(trailerButtonTapped))
            trailerButton.addGestureRecognizer(tapGesture)
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.showLoading()
        setupNavbarButtons()
        fetchMovie()
    }

    func setupNavbarButtons() {
        let favouriteButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(favouriteButtonTapped))
        favouriteButton.tintColor = UIColor.systemPink
        self.navigationItem.rightBarButtonItem = favouriteButton
    }
    
    @objc func trailerButtonTapped() {
        guard let detailedMovie = detailedMovie else { return }
        // look for detailedMovie.vides.results and if the site is youtube and key is not null get key
        detailedMovie.videos?.results?.forEach({ (video) in
            if video.site == "YouTube" && video.key != nil {
                if let url = URL(string: "https://www.youtube.com/watch?v=\(video.key!)") {
                    UIApplication.shared.open(url)
                    return
                }
            }
        })
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
                        AlertManager.shared.showErrorAlert(title: NSLocalizedString("error", comment: "an error title"), message: error.localizedDescription, viewController: self)
                }
            }
            if let castUrl = APIManager.shared.getMovieCastUrl(movieId: movieId) {
                NetworkManager.shared.fetchData(url: castUrl) { (result: Result<MovieCredit, AFError>) in
                    switch result {
                        case .success(let credits):
                            self.castList = credits.cast
                            self.castCollectionView.reloadData()
                        case .failure(let error):
                            AlertManager.shared.showErrorAlert(title: NSLocalizedString("error", comment: "an error title"), message: error.localizedDescription, viewController: self)
                    }
                }
            }
            
        }
    }
    
    func updateUI() {
        guard let detailedMovie else { return }
        // If the movie has any recommendation set isHidden false for label
        if detailedMovie.recommendations?.results?.count ?? 0 > 0 {
            self.recommendationLabel.isHidden = false
        }
        
        // Add watchProviders if there is any
        self.watchProvidersView.addWatchProviderIcon(watchProviders: detailedMovie.watchProviders)
        
        // update navbar item if already favourited
        if FavouriteManager.shared.isFavourite(movieId: detailedMovie.id ?? 0) {
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: Constants.iconNameForFavouriteMovie)
        }
        
        // UI Labels
        movieNameLabel.text = (detailedMovie.originalTitle ?? "")
        movieOverviewLabel.text = detailedMovie.overview
        bottomStackView.setCustomSpacing(15, after: movieOverviewLabel)
        voteAverageLabel.text = String(detailedMovie.voteAverage?.rounded(toPlaces: 1) ?? 0) + " / 10"
        releaseDateLabel.text = detailedMovie.releaseDate?.getMonthAndYearWithLocale()
        detailedMovie.genres?.forEach {
            let genreView = GenreView()
            genreView.configure(genre: $0)
            self.genresStackView.addArrangedSubview(genreView)
        }
        flagLabel.text = detailedMovie.originalLanguage?.uppercased()
        flagImageView.image = Flag(countryCode: detailedMovie.productionCompanies?.first?.originCountry ?? "")?.image(style: .roundedRect)

        moviePosterImageView.setImageFromPath(isOriginalSize: true, path: detailedMovie.backdropPath ?? "") { image in
            self.moviePosterImageView.hideLoading()
        }
        budgetLabel.text = String(detailedMovie.budget ?? 0).convertToShortNumberFormat()
        revenueLabel.text = String(detailedMovie.revenue ?? 0).convertToShortNumberFormat()
        runtimeLabel.text = String(detailedMovie.runtime ?? 0) + NSLocalizedString("shortMin", comment: "that describes minutes")
    }

    
}


// MARK: Custom Delegate Methods

extension MovieDetailViewController: ViewControllerNavigationHandlerDelegate {
    func dismissAndNavigateToMovieDetail(movie: Movie) {
        if let presentedViewController {
            presentedViewController.dismiss(animated: true) {
                self.navigateToMovieDetail(movie: movie)
            }
        }
    }
}
