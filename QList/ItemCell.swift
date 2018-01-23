//
//  ItemCell.swift
//  QList
//
//  Created by Home on 1/23/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var checkMark: UISwitch!
    @IBOutlet weak var itemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
