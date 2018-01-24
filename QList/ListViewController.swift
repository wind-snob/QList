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
    var foundItems = [Item]()
    
    var selectedItems: [Item] {
        return items.filter({ (item: Item) -> Bool in
            return item.isSelected
        })
    }
    
    let searchBar = UISearchBar()
    @IBOutlet weak var tableView: UITableView!
    
    // given item name returns its index in the items array
    func indexOfItem(withName name:String) -> Int? {
        let index = items.index { (item: Item) -> Bool in
            return item.name.lowercased() == name.lowercased()
        }
        return index
    }
    
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

extension ListViewController: UITableViewDelegate, UITableViewDataSource, ItemCellDelegate {
    
    // ItemCellDelegate protocol implementation
    func didUpdateCell(withLabel label: UILabel, andCheckmark checkmark: UISwitch) {
        
        // update the model
        guard let name = label.text else {
            return
        }
        print("Update checkmark on label = \(name)")
        let index = items.index { (item: Item) -> Bool in
            return item.name.lowercased() == name.lowercased()
        }
        
        if let index = index {
            items[index].isCompleted = checkmark.isOn
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchBarEmpty {
            return selectedItems.count
        } else {
            return foundItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        let itemName: String
        let isItemSelected: Bool
        let isCheckmarkOn: Bool
        
        itemCell.delegate = self
        
        if isSearchBarEmpty {
            // when no search then show selected items only
            itemName = selectedItems[indexPath.row].name
            isItemSelected = selectedItems[indexPath.row].isSelected
            isCheckmarkOn = selectedItems[indexPath.row].isCompleted
        } else {
            // when search is active then show search results
            itemName = foundItems[indexPath.row].name
            isItemSelected = foundItems[indexPath.row].isSelected
            // do not show checkmark status
            isCheckmarkOn = false
        }
        
        itemCell.itemCheckmark.setOn(isCheckmarkOn, animated: true)
        itemCell.itemLabel.text = itemName
        
        if isItemSelected {
            itemCell.accessoryType = .checkmark
        } else {
            itemCell.accessoryType = .none
        }
        return itemCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // only allow to select cell in search results
        if isSearchBarEmpty {
            return
        }
        
        guard let itemCell = tableView.cellForRow(at: indexPath) as? ItemCell else {
            return
        }
        // get the corresponding item and negate the selected status
        let selectedFoundItem = foundItems[indexPath.row]
        let index = items.index { (item: Item) -> Bool in
            return item.name.lowercased() == selectedFoundItem.name.lowercased()
        }
        guard let itemIndex = index else {
            return
        }
        items[itemIndex].isSelected = !items[itemIndex].isSelected
        toggleSelection(for: itemCell, withState: items[itemIndex].isSelected)
    }
    
    func toggleSelection(for cell: ItemCell, withState isSelected: Bool) {
        if !isSelected {
            cell.accessoryType = .none
            cell.itemLabel?.textColor = UIColor.black
        } else {
            cell.accessoryType = .checkmark
            cell.itemLabel?.textColor = UIColor.gray
        }
    }
}

// MARK: Search Bar Utilities

extension ListViewController {
    
    var isSearchBarEmpty: Bool {
        // Returns true if the text is empty or nil
        return searchBar.text?.isEmpty ?? true
    }
    
    func searchBarSetup() {
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Add new item"
        //searchBar.scopeButtonTitles = ["Selected Items", "All Items"]
        //searchBar.showsScopeBar = true
        navigationItem.titleView = searchBar
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchBar text did change")
        if isSearchBarEmpty {
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
