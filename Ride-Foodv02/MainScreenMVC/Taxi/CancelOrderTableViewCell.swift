//
//  CancelOrderTableViewCell.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 27.09.2021.
//

import UIKit

class CancelOrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel! { didSet {
        titleLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
    }}
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
