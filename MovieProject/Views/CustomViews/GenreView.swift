//
//  GenreView.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 1.08.2023.
//

import UIKit

class GenreView: UIView {
    // a text for genre
    private var genreLabel: UILabel!
    func configure(genre: Genre) {
        genreLabel = UILabel()
        genreLabel.text = genre.name
        genreLabel.textColor = UIColor(named: "genreLabel")
        // semibold
        genreLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.backgroundColor = UIColor(named: "genreBackground")
        self.addSubview(genreLabel)
        NSLayoutConstraint.activate([
            genreLabel.topAnchor.constraint(equalTo: self.topAnchor),
            genreLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            genreLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            genreLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            genreLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            genreLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    
        
    }

    
    
    

}
