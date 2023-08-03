//
//  CustomListsViewController.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 2.08.2023.
//

import UIKit

class CustomListsViewController: UIViewController {
    private(set) var customLists: [CustomList] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var refreshController = UIRefreshControl()
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.refreshControl = self.refreshController
            tableView.registerNib(with: String(describing: CustomListTableViewCell.self))
            tableView.delegate = self
            tableView.dataSource = self
            refreshController.addTarget(self, action: #selector(getCustomLists), for: .valueChanged)
        }
    }
    @IBOutlet private weak var searchBar: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let newListButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(newListButtonTapped))
        self.navigationItem.rightBarButtonItem = newListButton
        
        getCustomLists()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getCustomLists()
    }
    
    @objc func newListButtonTapped() {
        AlertManager.shared.showNewCustomListAlert(viewController: self) { status in
            if status {
                self.getCustomLists()
            }
        }
    }
    
    @objc func getCustomLists() {
        CustomListManager.shared.getAllCustomLists { customLists in
            self.customLists = customLists
        }
        refreshController.endRefreshing()
    }
}


extension CustomListsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomListTableViewCell.self), for: indexPath) as? CustomListTableViewCell {
            cell.configure(with: customLists[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToCustomListDetail(list: customLists[indexPath.row])
    }
}

