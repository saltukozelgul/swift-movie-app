//
//  GenreCollectionViewCell.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 4.08.2023.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var genreNameLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.setCornerRadius(15)
    }
    
    func configure(with genre: Genre?) {
        self.genreNameLabel.text = genre?.name
        if (genre?.id == -1) {
            self.iconImageView.image = UIImage(systemName: "plus.circle")
        } else {
            self.iconImageView.image = UIImage(systemName: "minus.circle")?.withTintColor(.red)
        }
    }
    
    
}
