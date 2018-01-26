//
//  ListViewController.swift
//  QList
//
//  Created by Home on 1/21/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UISearchBarDelegate {
    
    var items = [Item(name: "Apples"),
                 Item(name: "Chicken"),
                 Item(name: "Coffee"),
                 Item(name: "Corn"),
                 Item(name: "Cranberries"),
                 Item(name: "Bacon"),
                 Item(name: "Bagels"),
                 Item(name: "Bananas"),
                 Item(name: "Bread"),
                 Item(name: "Butter"),
                 Item(name: "Eggs"),
                 Item(name: "Flour"),
                 Item(name: "Ginger"),
                 Item(name: "Lemon"),
                 Item(name: "Mayo"),
                 Item(name: "Milk"),
                 Item(name: "Pastry"),
                 Item(name: "Popcorn"),
                 Item(name: "Potatoes"),
                 Item(name: "Salmon"),
                 Item(name: "Sugar"),
                 Item(name: "Spinach"),
                 Item(name: "Steak"),
                 Item(name: "Turkey"),
                 Item(name: "Wine"),
                 Item(name: "Vinegar"),
                 Item(name: "Yogurt"),]
    
    var foundItems = [Item]()
    
    var searchBarIsInFocus = false
    
    var selectedItems: [Item] {
        return items.filter({ (item: Item) -> Bool in
            return item.isSelected
        })
    }
    
    var notSelectedItems: [Item] {
        return items.filter({ (item: Item) -> Bool in
            return !item.isSelected
        })
    }
    
    let searchBar = UISearchBar()
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func clearListButtonTap(_ sender: UIButton) {
        
        for item in selectedItems {
            if let index = indexOfItem(withName: item.name) {
                items[index].isSelected = false
            }
        }
        tableView.reloadData()
    }
    
    
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
        
        let nib = UINib(nibName: "DescriptionCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DescriptionCell")
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
        if searchBarIsEmpty {
            
            if searchBarIsInFocus {
                print("Edit begin.....")
                return notSelectedItems.count
            } else {
                return selectedItems.count
            }
        } else {
            return foundItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let itemsToDisplay: [Item]?
        var showCheckmark: Bool?
        
        if searchBarIsEmpty {
            if searchBarIsInFocus {
                // when searchbar selected and no search text
                itemsToDisplay = notSelectedItems
                showCheckmark = false
            } else {
                // when searchbar not selected and no search text then show selected items only
                itemsToDisplay = selectedItems
                showCheckmark = true
            }
        } else {
            // when searchbar selected and there is search text then show search results
            itemsToDisplay = foundItems
            showCheckmark = false
        }
        
        if showCheckmark! {
            let itemCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
            itemCell.delegate = self
            itemCell.itemLabel.text = itemsToDisplay![indexPath.row].name
            itemCell.itemCheckmark.setOn(itemsToDisplay![indexPath.row].isCompleted, animated: true)
            return itemCell
        } else {
            let itemCell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as! DescriptionCell
            itemCell.itemLabel.text = itemsToDisplay![indexPath.row].name
            return itemCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // do not allow to select cell in...
        if searchBarIsEmpty && !searchBarIsInFocus {
            return
        }
        // get the corresponding item and negate the selected status
        let selectedItem: Item
        if searchBarIsEmpty {
            selectedItem = notSelectedItems[indexPath.row]
        } else {
            selectedItem = foundItems[indexPath.row]
        }
        
        if let itemIndex = indexOfItem(withName: selectedItem.name) {
            items[itemIndex].isSelected = !items[itemIndex].isSelected
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
    
    var searchBarIsEmpty: Bool {
        // Returns true if the text is empty or nil
        return searchBar.text?.isEmpty ?? true
    }
    
    func searchBarSetup() {
        searchBar.delegate = self
        searchBar.showsCancelButton = true
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
        tableView.reloadData()
    }
    
    // MARK: Add new item
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("......searchBarTextDidEndEditing")
        
        searchBarIsInFocus = false
        
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
        searchBarIsInFocus = true
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
