//
//  ListViewController.swift
//  QList
//
//  Created by Home on 1/21/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UISearchBarDelegate {
    
    var items = [Item(name: "Milk"), Item(name: "Bread"), Item(name: "Eggs"), Item(name: "Chicken"), Item(name: "Coffee")]
    let selectedItems = [Item]()
    
    let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarSetup()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: Search Bar Utilities
extension ListViewController {
    
    func searchBarSetup() {
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Add new item"
        searchBar.scopeButtonTitles = ["Selected Items", "All Items"]
        searchBar.showsScopeBar = true
        navigationItem.titleView = searchBar
    }
    
    func isSearchBarEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchBar.text?.isEmpty ?? true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

  // MARK: UITableView Delegate methods
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        itemCell.textLabel?.text = items[indexPath.row].name
        itemCell.accessoryType = .none
        return itemCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let itemCell = tableView.cellForRow(at: indexPath) else {
            return
        }
        // get the corresponding item and negate the completed status
        var item = items[indexPath.row]
        item.isCompleted = !item.isCompleted
        toggleCheckbox(for: itemCell, withStatus: item.isCompleted)
        items[indexPath.row] = item
        
    }
    
    func toggleCheckbox(for cell: UITableViewCell, withStatus isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.black
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor.gray
            cell.detailTextLabel?.textColor = UIColor.gray
        }
    }
}
