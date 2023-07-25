//
//  CastView.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 25.07.2023.
//

import Foundation
import UIKit

class CastView: UIView {
    // ONE IMAGE AND 2 LABEL ONE FOR NAME ONE FORE CHRACKETER NAME
    // CREATE THİS PROGRAMMATICALLY
    
    var castImageView = UIImageView()
    var nameLabel = UILabel()
    var characterLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageView()
        configureNameLabel()
        configureCharacterLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(cast: Cast) {
        nameLabel.text = cast.name
        characterLabel.text = cast.character
        if let profilePath = cast.profilePath {
            castImageView.setImageFromPath(path: profilePath)
        }
    }
    
    private func configureImageView() {
        addSubview(castImageView)
        castImageView.translatesAutoresizingMaskIntoConstraints = false
        castImageView.layer.cornerRadius = 10
        castImageView.clipsToBounds = true
        
      
        castImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        castImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        NSLayoutConstraint.activate([
            castImageView.topAnchor.constraint(equalTo: self.topAnchor),
            castImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            castImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            castImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8)
        ])
    }
    
    private func configureNameLabel() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 2
        nameLabel.adjustsFontSizeToFitWidth = false
        nameLabel.font = nameLabel.font.withSize(12)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: castImageView.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureCharacterLabel() {
        addSubview(characterLabel)
        characterLabel.translatesAutoresizingMaskIntoConstraints = false
        characterLabel.numberOfLines = 2
        characterLabel.adjustsFontSizeToFitWidth = false
        characterLabel.font = characterLabel.font.withSize(10)
        NSLayoutConstraint.activate([
            characterLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            characterLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            characterLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            characterLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    
    
}
