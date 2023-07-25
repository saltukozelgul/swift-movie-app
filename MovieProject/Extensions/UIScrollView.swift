//
//  CollectionReusableView.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 25.07.2023.
//

import UIKit

extension UIScrollView {
    
    func registerNib(with identifier: String) {
        let nib = UINib(nibName: String(describing: identifier), bundle: nil)
        if let tableView = self as? UITableView {
            tableView.register(nib, forCellReuseIdentifier: identifier)
        } else if let collectionView = self as? UICollectionView {
            collectionView.register(nib, forCellWithReuseIdentifier: identifier)
        }
    }
}

