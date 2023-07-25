//
//  MovieDetailViewController.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 23.07.2023.
//

import UIKit
import FlagKit

class MovieDetailViewController: UIViewController {
    // private tanımlamak daha mantıklı
    var movieId: Int?
    var detailedMovie: Movie?
    var cast: [Cast]?
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    
    // Scroll view outlets
    @IBOutlet weak var castStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMovie()
    }
    
    func fetchMovie() {
        if let movieId {
            // loadingler daha generic olabilir e
            loadingIndicator.startAnimating()
            let url = NetworkConstants.getMovieDetailUrl(movieId: movieId)
            // use fetch data generic
            NetworkManager.shared.fetchData(url: url) { (movie: Movie?) in
                if let movie {
                    self.detailedMovie = movie
                    self.updateUI()
                    self.loadingIndicator.stopAnimating()
                    self.loadingView.isHidden = true
                } else {
                    // error alert will implemented
                }
            }
            let castUrl = NetworkConstants.getMovieCastUrl(movieId: movieId)
            NetworkManager.shared.fetchData(url: castUrl) { (credits: MovieCredit?) in
                self.cast = credits?.cast
                if let cast = self.cast {
                    self.addToCastStackView(cast: cast)
                }
            }
        }
    }
 
    func updateUI() {
        guard let detailedMovie = detailedMovie else { return }
        
        movieNameLabel.text = (detailedMovie.originalTitle ?? "")
        movieOverviewLabel.text = detailedMovie.overview
        voteAverageLabel.text = String(detailedMovie.voteAverage?.rounded(toPlaces: 1) ?? 0) + " / 10"
        releaseDateLabel.text = detailedMovie.releaseDate?.convertToLocalizedDateString()
        genresLabel.text = detailedMovie.genres?.map { $0.name ?? "" }.joined(separator: ", ")
        moviePosterImageView.setImageFromPath(path: detailedMovie.backdropPath ?? "unknown")
        budgetLabel.text = String(detailedMovie.budget ?? 0).convertToCurrency()
        revenueLabel.text = String(detailedMovie.revenue ?? 0).convertToCurrency()
        runtimeLabel.text = String(detailedMovie.runtime ?? 0) + NSLocalizedString("shortMin", comment: "that describes minutes")
    }
}



// MARK: Cast Section

extension MovieDetailViewController {
    func addToCastStackView(cast: [Cast]) {
        for castMember in cast {
            // CastView has set method that accept Cast Model
            let castView = CastView()
            castView.set(cast: castMember)
            castStackView?.addArrangedSubview(castView)
        }
    }
}
