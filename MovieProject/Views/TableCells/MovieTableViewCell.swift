//
//  MovieTableViewCell.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 23.07.2023.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {
    private var movieId: Int?
    
    @IBOutlet private weak var addFavouriteButton: UIButton!
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var movieOverviewLabel: UILabel!
    @IBOutlet private weak var movieRelaseDateLabel: UILabel!
    @IBOutlet private weak var movieVoteAverageLabel: UILabel!
    @IBAction private func addFavouriteButtonTapped(_ sender: UIButton) {
        guard let movieId = movieId else { return }
        FavouriteManager.shared.toggleFavourite(movieId: movieId) { isSuccess, newState in
            if isSuccess {
                addFavouriteButton.setImageForFavouriteButton(with: newState)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCellForDisplay(movie: Movie) {
        movieId = movie.id
        movieTitleLabel.text = movie.title
        movieOverviewLabel.text = movie.overview
        movieRelaseDateLabel.text = movie.releaseDate?.getOnlyYear()
        movieVoteAverageLabel.text = String(movie.voteAverage?.rounded(toPlaces: 1) ?? 0) + " / 10"
        movieImageView.setImageFromPath(path: movie.posterPath ?? "") { image in
            return
        }
        checkFavouriteState()
    }
    
    func checkFavouriteState() {
        guard let movieId = movieId else { return }
        addFavouriteButton.setImageForFavouriteButton(with: FavouriteManager.shared.isFavourite(movieId: movieId))
    }
}
