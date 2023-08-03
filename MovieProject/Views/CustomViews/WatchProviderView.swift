//
//  WatchProviderView.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 31.07.2023.
//

import UIKit

class WatchProviderView: UIStackView {
    private var watchProviders: WatchProviders?
    func addWatchProviderIcon(watchProviders: WatchProviders?) {
        self.watchProviders = watchProviders
        let isoCode = String(NSLocalizedString("isoCode", comment: "").suffix(2))
        guard let provider = watchProviders?.results?[isoCode] else {
            return
        }
        
        guard let flatRates = provider.flatrate else {
            return
        }
        
        // for every logopath
        for flatRate in flatRates {
            guard let logoPath = flatRate.logoPath else {
                continue
            }
            
            let imageView = UIImageView()
            
            // add tapGesture for this view
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            imageView.addGestureRecognizer(tapGesture)
            imageView.isUserInteractionEnabled = true
            
            // Set normal icon size
            imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
            imageView.setCornerRadius(10)
            imageView.setImageFromPath(path: logoPath) { image in
                self.addArrangedSubview(imageView)
                self.superview?.isHidden = false
            }
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let isoCode = String(NSLocalizedString("isoCode", comment: "").suffix(2))
        guard let provider = watchProviders?.results?[isoCode] else {
            return
        }
        
        guard let link = provider.link else {
            return
        }
        
        guard let url = URL(string: link) else {
            return
        }
        
        UIApplication.shared.open(url)
    }

}
