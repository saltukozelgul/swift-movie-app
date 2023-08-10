//
//  CustomListsViewController.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 2.08.2023.
//

import UIKit

class CustomListsViewController: UIViewController {
    // Properties
    private var customLists: [CustomList] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var isSearching = false
    private var filteredCustomLists: [CustomList] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var refreshController = UIRefreshControl()
    
    // IBOutlets
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.refreshControl = self.refreshController
            tableView.registerNib(with: CustomListTableViewCell.self)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.keyboardDismissMode = .onDrag
            refreshController.addTarget(self, action: #selector(getCustomLists), for: .valueChanged)
        }
    }
    @IBOutlet private weak var searchBar: UITableView!
    
    // Life Cycle Methods
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
    
    // Custom methods
    @objc func newListButtonTapped() {
        AlertManager.shared.showNewCustomListAlert(viewController: self) { status in
            self.getCustomLists()
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
        return isSearching ? filteredCustomLists.count : customLists.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomListTableViewCell.self), for: indexPath) as? CustomListTableViewCell {
            let list = isSearching ? filteredCustomLists[indexPath.row] : customLists[indexPath.row]
            cell.configure(with: list)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToCustomListDetail(list: customLists[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableConstants.heightForCustomListCell
    }
    
    // disable delete for first row which is favs
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let list = isSearching ? filteredCustomLists[indexPath.row] : customLists[indexPath.row]
        return list.customListId == CustomListConstants.idForFavouritesList ? false : true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let list = customLists[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            CustomListManager.shared.deleteCustomList(customListId: list.customListId ?? "") { result in
                if result {
                    self.customLists.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
            }
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 23, weight: .bold, scale: .large))
        deleteAction.backgroundColor = .systemRed
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            AlertManager.shared.editCustomListAlert(viewController: self, customListId: list.customListId ?? "") { result in
                if result {
                    self.getCustomLists()
                }
            }
            completionHandler(true)
        }
        editAction.image = UIImage(systemName: "pencil")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .large))
        editAction.backgroundColor = .systemOrange
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}


// MARK: Search Bar Delegate
extension CustomListsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performSearch(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func performSearch(_ searchText: String) {
        if (searchText.isEmpty || searchText == "") {
            isSearching = false
            filteredCustomLists = []
            tableView.reloadData()
            return
        }
        isSearching = true
        filteredCustomLists = customLists.filter({
            if let name = $0.customListName?.lowercased() {
                return name.contains(searchText.lowercased())
            }
            return false
        })
        tableView.reloadData()
    }
    
}
