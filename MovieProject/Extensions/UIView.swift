//
//  File.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 25.07.2023.
//

import UIKit

extension UIView {
    func showLoading() {
        let loadingView = LoadingView(frame: frame)
        self.addSubview(loadingView)
    }
    
    func hideLoading() {
        if let loadingView = self.subviews.first(where: { $0 is LoadingView }) {
            loadingView.removeFromSuperview()
        }
    }
    
}
