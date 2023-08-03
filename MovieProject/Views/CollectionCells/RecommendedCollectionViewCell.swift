//
//
//  RecommendedCollectionViewCell.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 31.07.2023.
//

import UIKit

class RecommendedCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(_ movie: Movie) {
        if let posterPath = movie.posterPath {
            posterImageView.setCornerRadius(10)
            posterImageView.setImageFromPath(path: posterPath) { image in
                if image == nil {
                    
                }
                return
            }
        }
    }
}
