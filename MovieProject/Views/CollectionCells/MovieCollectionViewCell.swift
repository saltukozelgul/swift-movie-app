//
//  MovieCollectionViewCell.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 8.08.2023.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var posterImageView: UIImageView! {
        didSet {
            posterImageView.setCornerRadius(10)
            self.showLoading()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with movie: Movie) {
        posterImageView.setCornerRadius(10)
        posterImageView.setImageFromPath(path: movie.posterPath ?? "") { image in
            self.hideLoading()
            if image == nil {
                self.posterImageView.image = UIImage(named: "noImage")
            }
        }
    }
}
