//
//  CastDetailViewController.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 23.07.2023.
//

import UIKit

class CastDetailViewController: UIViewController {
    var personId: Int?
    private var detailedCast: Cast?
    
    @IBOutlet weak var castImageView: UIImageView!
    @IBOutlet weak var placeOfBirthLabel: UILabel!
    @IBOutlet weak var deathdayHeaderLabel: UILabel!
    @IBOutlet weak var deathdayLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.showLoading()
        fetchPerson()
    }
    
    func fetchPerson() {
        if let personId {
            let url = NetworkUrlBuilder.getPersonDetailUrl(personId: personId)
            NetworkManager.shared.fetchData(url: url) { (person: Cast?) in
                if let person {
                    self.detailedCast = person
                    self.updateUI()
                    self.view.hideLoading()
                } else {
                    // error alert will implemented
                }
            }
        }
    }
    
    func updateUI() {
        if let person = detailedCast {
            nameLabel.text = person.name
            bioLabel.text = person.biography
            birthdayLabel.text = person.birthday?.convertToLocalizedDateString()
            if let deathday = person.deathday {
                deathdayLabel.text = deathday.convertToLocalizedDateString()
            } else {
                deathdayHeaderLabel.isHidden = true
                deathdayLabel.isHidden = true
            }
            placeOfBirthLabel.text = person.placeOfBirth
            if let profilePath = person.profilePath {
                castImageView.setImageFromPath(path: profilePath)
            }
        }
    
    }
}
