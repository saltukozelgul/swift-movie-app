//
//
//  RecommendedCollectionViewCell.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 31.07.2023.
//

import UIKit

class RecommendedCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var posterImageView: UIImageView! {
        didSet {
            self.showLoading()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(_ movie: Movie) {
        
        posterImageView.setCornerRadius(10)
        posterImageView.setImageFromPath(path: movie.posterPath ?? "") { image in
            self.hideLoading()
            if image == nil {
                self.posterImageView.image = UIImage(named: "noImage")
            }
        }
    }
}
