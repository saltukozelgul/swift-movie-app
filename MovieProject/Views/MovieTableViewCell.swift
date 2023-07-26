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
    
    
    @IBAction func addFavouriteButtonTapped(_ sender: UIButton) {
        guard let movieId = movieId else { return }
        FavouriteManager.shared.toggleFavourite(movieId: movieId) { isSuccess, newState in
            if isSuccess {
                updateFavouriteButtonView(newState: newState)
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
        movieRelaseDateLabel.text = String(movie.releaseDate?.prefix(4) ?? "")
        movieVoteAverageLabel.text = String(movie.voteAverage?.rounded(toPlaces: 1) ?? 0) + " / 10"
        movieImageView.setImageFromPath(path: movie.posterPath ?? "")
        checkFavouriteState()
    }
    
    func updateFavouriteButtonView(newState: Bool) {
        if newState {
            addFavouriteButton.setImage(UIImage(systemName: Constants.iconNameForFavouriteMovie), for: .normal)
        } else {
            addFavouriteButton.setImage(UIImage(systemName: Constants.iconNameForNotFavouriteMovie), for: .normal)
        }
    }
    
    func checkFavouriteState() {
        guard let movieId = movieId else { return }
        updateFavouriteButtonView(newState: FavouriteManager.shared.isFavourite(movieId: movieId))
    }
}
