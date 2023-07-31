//
//  CastDetailViewController.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 23.07.2023.
//

import UIKit
import Alamofire

class CastDetailViewController: UIViewController {
    var personId: Int?
    private var detailedCast: Cast?
    
    
    @IBOutlet private weak var castImageView: UIImageView!
    @IBOutlet private weak var placeOfBirthLabel: UILabel!
    @IBOutlet private weak var deathdayHeaderLabel: UILabel!
    @IBOutlet private weak var deathdayLabel: UILabel!
    @IBOutlet private weak var birthdayLabel: UILabel!
    @IBOutlet private weak var bioLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet weak var bottomCardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.showLoading()
        bottomCardView.setCornerRadius(30)
        fetchPerson()
    }
    
    func fetchPerson() {
        if let personId, let url = APIManager.shared.getPersonDetailUrl(personId: personId)   {
            NetworkManager.shared.fetchData(url: url) { (result: Result<Cast, AFError>) in
                switch result {
                    case .success(let person):
                        self.detailedCast = person
                        self.updateUI()
                        self.view.hideLoading()
                    case .failure(let error):
                        ErrorAlertManager.shared.showAlert(title: NSLocalizedString("error", comment: "an error title"), message: error.localizedDescription, viewController: self)
                
                }
            }
        }
    }
    
    func updateUI() {
        if let person = detailedCast {
            nameLabel.text = person.name
            bioLabel.text = person.biography
            birthdayLabel.text = person.birthday?.getFullDateWithLocale()
            if let deathday = person.deathday {
                deathdayLabel.text = deathday.getFullDateWithLocale()
            } else {
                deathdayHeaderLabel.isHidden = true
                deathdayLabel.isHidden = true
            }
            placeOfBirthLabel.text = person.placeOfBirth
            if let profilePath = person.profilePath {
                castImageView.setImageFromPath(path: profilePath) { image in
                    return
                }
            }
        }
    
    }
}
