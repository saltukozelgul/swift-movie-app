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
    
    func setCornerRadius(_ value: CGFloat) {
        self.layer.cornerRadius = value
        self.layer.masksToBounds = true
    }
    
    func setGradientBackground(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.locations = [0.4, 0.9]
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
