//
//  MovieDetailViewController.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 23.07.2023.
//

import UIKit

class MovieDetailViewController: UIViewController {
    var movieId: Int?
    var detailedMovie: Movie?
    
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMovie()
    }
    
    func fetchMovie() {
        if let movieId {
            let url = NetworkConstants.movieDetailUrl + "\(movieId)" + NetworkConstants.suffixUrl
            // use fetch data generic
            NetworkManager.shared.fetchData(url: url) { (movie: Movie?) in
                self.detailedMovie = movie
                self.updateUI()
            }
        }
    }
    
    func updateUI() {
        movieNameLabel.text = detailedMovie?.title
        movieOverviewLabel.text = detailedMovie?.overview
        voteAverageLabel.text = String(detailedMovie?.voteAverage?.rounded(toPlaces: 1) ?? 0) + " / 10"
        releaseDateLabel.text = detailedMovie?.releaseDate?.convertToLocalizedDateString()
        genresLabel.text = detailedMovie?.genres?.map { $0.name ?? "" }.joined(separator: ", ")
        moviePosterImageView.setImageFromPath(path: detailedMovie?.backdropPath ?? "unknown")
        budgetLabel.text = String(detailedMovie?.budget ?? 0).convertToCurrency()
        revenueLabel.text = String(detailedMovie?.revenue ?? 0).convertToCurrency()
    }
}
