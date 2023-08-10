//
//  CastCollectionViewCell.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 25.07.2023.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var castImageView: UIImageView! {
        didSet {
            castImageView.translatesAutoresizingMaskIntoConstraints = false
            castImageView.layer.cornerRadius = 10
            castImageView.clipsToBounds = true
            NSLayoutConstraint.activate([
                castImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            ])
        }
    }
    @IBOutlet private weak var castNameLabel: UILabel!
    @IBOutlet private weak var castCharacterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with cast: Cast) {
        castNameLabel.text = cast.name
        castCharacterLabel.text = cast.character
        castImageView.setImageFromPath(path: cast.profilePath ?? "") { image in
            if image == nil {
                self.castImageView.image = UIImage(named: "noImage")
            }
        }
    }
}
