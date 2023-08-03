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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with list: CustomList) {
        if list.customListId == CLConstants.idForFavouritesList {
            self.listName.text = NSLocalizedString("favList", comment: "a text for table name for favourites")
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
