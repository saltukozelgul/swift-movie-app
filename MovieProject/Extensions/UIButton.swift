//
//  UIButton+Favourite.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 26.07.2023.
//

import UIKit

extension UIButton {
    
    func setFavouriteButtonImage(isFavourite: Bool) {
        if isFavourite {
            self.setImage(UIImage(systemName: Constants.iconNameForFavouriteMovie), for: .normal)
        } else {
            self.setImage(UIImage(systemName: Constants.iconNameForNotFavouriteMovie), for: .normal)
        }
    }
    
}
