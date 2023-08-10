//
//  CustomListTableViewCell.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 2.08.2023.
//

import UIKit

class CustomListTableViewCell: UITableViewCell {
    @IBOutlet private weak var listName: UILabel!
    @IBOutlet private weak var listMovieCount: UILabel!
    @IBOutlet private weak var listIconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with list: CustomList) {
        if list.customListId == CustomListConstants.idForFavouritesList {
            self.listName.text = NSLocalizedString("favList", comment: "a text for table name for favourites")
            self.listIconImageView.image = UIImage(systemName: "heart.fill")
            self.listIconImageView.tintColor = .systemPink
        } else {
            self.listIconImageView.image = UIImage(systemName: "bookmark")
           // symbol scale
            self.listIconImageView.preferredSymbolConfiguration = .init(scale: .large)
            self.listIconImageView.tintColor = .systemYellow
            self.listName.text = list.customListName
        }
        self.listMovieCount.text = String(list.movies?.count ?? 0)
    }
    
}
