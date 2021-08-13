//
//  MenuItemsTableViewCell.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 14.08.2021.
//

import UIKit

class MenuItemsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuItemLabel: UILabel!{ didSet {
        menuItemLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
    }}
    
    
    static let identifier = "MenuItemsCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
