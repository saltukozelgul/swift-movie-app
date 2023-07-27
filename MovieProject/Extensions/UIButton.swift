//
//  UIButton+Favourite.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 26.07.2023.
//

import UIKit

extension UIButton {
    
    func setImageForFavouriteButton(with condition: Bool, for state: UIControl.State = .normal) {
        let imageName = condition ? Constants.iconNameForFavouriteMovie : Constants.iconNameForNotFavouriteMovie
        self.setImage(UIImage(systemName: imageName), for: state)
    }
    
}

