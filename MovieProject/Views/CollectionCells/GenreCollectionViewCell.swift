//
//  GenreCollectionViewCell.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 4.08.2023.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var genreNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.setCornerRadius(15)
    }
    
    func configure(with genre: Genre?) {
        self.genreNameLabel.text = genre?.name
    }


}
