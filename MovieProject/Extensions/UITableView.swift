//
//  UITableView.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 6.08.2023.
//

import UIKit

extension UITableView {
    // If there is no item in tableView notify user with custom view
    func setEmptyView(title: String = NSLocalizedString("noDataTitle", comment: ""), message: String = NSLocalizedString("noDataMessage", comment: ""), isCustomList: Bool = false) {
        let emptyView = EmptyTableView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        emptyView.configure(title: title, message: message, isCustomList: isCustomList)
        self.backgroundView = emptyView
    }
    
    func restoreBackground() {
        self.backgroundView = nil
    }
    
}
