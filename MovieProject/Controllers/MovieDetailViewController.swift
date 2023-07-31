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
    private var detailedMovie: Movie?
    private var castList: [Cast]?
    
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
    
    // CollectionView
    @IBOutlet private weak var castCollectionView: UICollectionView!
    @IBOutlet private weak var watchProvidersView: WatchProviderView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        castCollectionView.registerNib(with: String(describing: CastCollectionViewCell.self))
        if let color = UIColor(named: "gradientBackground") {
            gradientView.setGradientBackground(colors: [color.withAlphaComponent(0.0).cgColor, color.cgColor])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.showLoading()
        fetchMovie()
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
        guard let detailedMovie = detailedMovie else { return }
        self.watchProvidersView.addWatchProviderIcon(watchProviders: detailedMovie.watchProviders)
        movieNameLabel.text = (detailedMovie.originalTitle ?? "")
        movieOverviewLabel.text = detailedMovie.overview
        voteAverageLabel.text = String(detailedMovie.voteAverage?.rounded(toPlaces: 1) ?? 0) + " / 10"
        releaseDateLabel.text = detailedMovie.releaseDate?.getMonthAndYearWithLocale()
        genresLabel.text = detailedMovie.genres?.map { $0.name ?? "" }.joined(separator: ", ")
        moviePosterImageView.setImageFromPath(path: detailedMovie.posterPath ?? "") { image in
            
        }
        budgetLabel.text = String(detailedMovie.budget ?? 0).convertToShortNumberFormat()
        revenueLabel.text = String(detailedMovie.revenue ?? 0).convertToShortNumberFormat()
        runtimeLabel.text = String(detailedMovie.runtime ?? 0) + NSLocalizedString("shortMin", comment: "that describes minutes")
    }

    
}


// MARK: CollectionView Methods

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.castList?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cast = self.castList?[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CastCollectionViewCell.self), for: indexPath) as! CastCollectionViewCell
        if let cast {
            cell.configure(with: cast)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: Cast detay sayfasına gidecek fonksiyon implement edilecek
        if let cast = self.castList?[indexPath.row] {
            navigateToCastDetail(cast: cast)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.widthForCastCell , height: Constants.heightForCastCell)
    }
}
