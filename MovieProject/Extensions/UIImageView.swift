//
//  UIImageView.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 24.07.2023.
//

import UIKit


extension UIImageView {
    
    func setImageFromPath(isOriginalSize: Bool = false, path: String, completion: @escaping (UIImage?) -> Void) {
        var urlString = NetworkConstants.baseImageUrl + path
        var image: UIImage? = nil
        if isOriginalSize {
            urlString = NetworkConstants.baseImageUrlForOriginalSize + path
        }
        guard let url = URL(string: urlString) else {
            return
        }
        self.kf.setImage(with: url) { (result) in
            switch result {
                case .success(let value):
                    image = value.image
                    completion(image)
                case .failure(let error):
                    print(error)
                    completion(nil)
            }
        }
    }
}

