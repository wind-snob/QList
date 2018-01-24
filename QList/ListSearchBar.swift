//
//  ListSearchBar.swift
//  QList
//
//  Created by Home on 1/24/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

class ListSearchBar: UISearchBar {

    var isSearchBarEmpty: Bool {
        // Returns true if the text is empty or nil
        return text?.isEmpty ?? true
    }
    
    func searchBarSetup() {
        showsCancelButton = false
        placeholder = "Add new item"
        scopeButtonTitles = ["Selected Items", "All Items"]
        showsScopeBar = true
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    // override func draw(_ rect: CGRect) {
        // Drawing code
    //}

}
