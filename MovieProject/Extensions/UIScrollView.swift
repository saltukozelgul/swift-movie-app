//
//  CollectionReusableView.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 25.07.2023.
//

import UIKit

extension UIScrollView {
        
    func registerNib(with cell: UIView.Type) {
        let identifier = String(describing: cell)
        let nib = UINib(nibName: identifier, bundle: nil)
        if let tableView = self as? UITableView {
            tableView.register(nib, forCellReuseIdentifier: identifier)
        } else if let collectionView = self as? UICollectionView {
            collectionView.register(nib, forCellWithReuseIdentifier: identifier)
        }
    }
}

