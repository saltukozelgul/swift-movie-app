//
//  UIImageView.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 24.07.2023.
//

import UIKit


extension UIImageView {
    
    func setImageFromPath(isOriginalSize: Bool = false, path: String, completion: @escaping (UIImage?) -> Void) {
        var urlString = ""
        if isOriginalSize {
            urlString = NetworkConstants.baseImageUrlForOriginalSize + path
        } else {
            urlString = NetworkConstants.baseImageUrl + path
        }
        guard let url = URL(string: urlString) else {
            return
        }
        self.kf.setImage(with: url) { (result) in
            switch result {
            case .success(let value):
                completion(value.image)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    
    }
}

