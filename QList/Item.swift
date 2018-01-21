//
//  Item.swift
//  QList
//
//  Created by Home on 1/21/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

struct Item {
    let name: String
    let addedBy: String
    var isSelected: Bool
    var isCompleted: Bool
    
    init(name: String) {
        self.name = name
        self.addedBy = "user@domain.com"
        self.isSelected = false
        self.isCompleted = false
    }
    
    init(name: String, isCompleted: Bool) {
        self.name = name
        self.addedBy = "user@domain.com"
        self.isSelected = false
        self.isCompleted = isCompleted
    }
    
}
