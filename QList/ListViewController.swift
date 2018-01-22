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
    var foundItems = [Item]()
    
    let searchBar = UISearchBar()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarSetup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: TableView Delegates

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchBarEmpty() {
            return items.count
        } else {
            return foundItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        let itemName: String
        let isItemCompleted: Bool
        
        if isSearchBarEmpty() {
            itemName = items[indexPath.row].name
            isItemCompleted = items[indexPath.row].isCompleted
        } else {
            itemName = foundItems[indexPath.row].name
            isItemCompleted = foundItems[indexPath.row].isCompleted
        }
        
        itemCell.textLabel?.text = itemName
        
        if isItemCompleted {
            itemCell.accessoryType = .checkmark
        } else {
            itemCell.accessoryType = .none
        }
        return itemCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let itemCell = tableView.cellForRow(at: indexPath) else {
            return
        }
        // get the corresponding item and negate the completed status
        var item = items[indexPath.row]
        item.isCompleted = !item.isCompleted
        toggleCheckbox(for: itemCell, withState: item.isCompleted)
        items[indexPath.row] = item
        
    }
    
    func toggleCheckbox(for cell: UITableViewCell, withState completed: Bool) {
        if !completed {
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

// MARK: Search Bar Utilities

extension ListViewController {
    
    func searchBarSetup() {
        searchBar.delegate = self
        searchBar.showsCancelButton = false
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchBar text did change")
        if isSearchBarEmpty() {
            searchBar.showsCancelButton = false
        } else {
            searchBar.showsCancelButton = true
        }
        searchResults(for: searchText)
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("......searchBarTextDidEndEditing")
        // add new item
        let item = Item(name: searchBar.text!)
        items.append(item)
        searchBar.text = ""
        tableView.reloadData()
    }
    
    func searchResults(for text: String) {
        foundItems = items.filter({ (item: Item) -> Bool in
            return item.name.lowercased().contains(text.lowercased())
        })
    }
}
