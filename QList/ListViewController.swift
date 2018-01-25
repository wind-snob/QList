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
    
    var searchBarBeginEditing = false
    
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
        if let name = label.text, let index = indexOfItem(withName: name) {
            items[index].isCompleted = checkmark.isOn
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchBarEmpty {
            
            if searchBarBeginEditing {
                print("Edit begin.....")
                return items.count
            } else {
                return selectedItems.count
            }
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
            
            if searchBarBeginEditing {
                print("Show all items.....")
                itemName = items[indexPath.row].name
                isItemSelected = items[indexPath.row].isSelected
                isCheckmarkOn = items[indexPath.row].isCompleted
            } else {
                // when no search then show selected items only
                itemName = selectedItems[indexPath.row].name
                isItemSelected = selectedItems[indexPath.row].isSelected
                isCheckmarkOn = selectedItems[indexPath.row].isCompleted
            }
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
        
        if let itemCell = tableView.cellForRow(at: indexPath) as? ItemCell {
            
            // get the corresponding item and negate the selected status
            let selectedItem = foundItems[indexPath.row]
            
            if let itemIndex = indexOfItem(withName: selectedItem.name) {
                items[itemIndex].isSelected = !items[itemIndex].isSelected
                setSelection(for: itemCell, withState: items[itemIndex].isSelected)
            }
        }
        // cancel search
        searchBar.text = nil
        searchBar.endEditing(true)
    }
    
    func setSelection(for cell: ItemCell, withState isSelected: Bool) {
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
// decided not to show the cancel button
//        if isSearchBarEmpty {
//            searchBar.showsCancelButton = false
//        } else {
//            searchBar.showsCancelButton = true
//        }
        searchResults(for: searchText)
        searchBarBeginEditing = false
        tableView.reloadData()
    }
    
    // MARK: Add new item
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("......searchBarTextDidEndEditing")
        // if search text not empty then add new item
        if let text = searchBar.text?.trimmingCharacters(in: .whitespaces) {
            if text != "" {
                // check if the name is already in the items table
                // if yes then update, if not then append new item with the name
                if let index = indexOfItem(withName: text.lowercased()) {
                    items[index].isSelected = true
                } else {
                    let item = Item(name: text, isSelected: true)
                    items.append(item)
                }
                searchBar.text = nil
            }
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidBeginEditing")
        // show all items when focus goes to searchbar
        searchBarBeginEditing = true
        //foundItems = items
        tableView.reloadData()
    }
    
    
    func searchResults(for text: String) {
        foundItems = items.filter({ (item: Item) -> Bool in
            // item name contains search text and item is not already selected
            return item.name.lowercased().contains(text.lowercased()) && !item.isSelected
        })
    }
}
