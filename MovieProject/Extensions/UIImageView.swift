//
//  UIImageView.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 24.07.2023.
//

import UIKit


extension UIImageView {
    
    func setImageFromPath(path: String) {
        let urlString = NetworkConstants.baseImageUrl + path
        guard let url = URL(string: urlString) else {
            return
        }
        self.kf.setImage(with: url)
    }
}

