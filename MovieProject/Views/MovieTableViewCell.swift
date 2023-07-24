//
//  MovieTableViewCell.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 23.07.2023.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak  var movieOverviewLabel: UILabel!
    @IBOutlet weak var movieRelaseDateLabel: UILabel!
    @IBOutlet weak var movieVoteAverageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCellForDisplay(movie: Movie) {
        movieTitleLabel.text = movie.title
        movieOverviewLabel.text = movie.overview
        movieRelaseDateLabel.text = String(movie.releaseDate?.prefix(4) ?? "")
        movieVoteAverageLabel.text = String(movie.voteAverage ?? 0) + " / 10"
        movieImageView.setImageFromPath(path: movie.posterPath ?? "")
    }
    
    
    
}
