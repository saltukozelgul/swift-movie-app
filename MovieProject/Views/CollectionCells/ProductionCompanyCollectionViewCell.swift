//
//  ProductionCompanyCollectionViewCell.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 8.08.2023.
//

import UIKit

class ProductionCompanyCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var productionCompanyImageView: UIImageView! {
        didSet {
            self.productionCompanyImageView.setCornerRadius(15)
        }
    }
    @IBOutlet private weak var productionCompanyNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with: ProductionCompany) {
        self.productionCompanyNameLabel.text = with.name
        if let imagePath = with.logoPath {
            self.productionCompanyImageView.setImageFromPath(path: imagePath) { image in
                if image == nil {
                    self.productionCompanyImageView.image = UIImage(named: "noImage")
                }
            }
        }
    }
    
}
