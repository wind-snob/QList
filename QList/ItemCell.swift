//
//  ItemCell.swift
//  QList
//
//  Created by Home on 1/23/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

protocol ItemCellDelegate {
    func didUpdateCell(withLabel label: UILabel, andCheckmark checkmark: UISwitch)
}

class ItemCell: UITableViewCell {
    
    var delegate: ItemCellDelegate?
    
    @IBOutlet weak var itemCheckmark: UISwitch!
    @IBOutlet weak var itemLabel: UILabel!
    
    @IBAction func toggleCheckmark(_ sender: UISwitch) {
        print("Checkmark toggled.....")
        delegate?.didUpdateCell(withLabel: itemLabel, andCheckmark: itemCheckmark)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
