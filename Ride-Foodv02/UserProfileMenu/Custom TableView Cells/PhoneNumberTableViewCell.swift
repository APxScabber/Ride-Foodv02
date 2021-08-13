//
//  PhoneNumberTableViewCell.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 14.08.2021.
//

import UIKit

class PhoneNumberTableViewCell: UITableViewCell {
    
    @IBOutlet weak var phoneNumberLabel: UILabel!{ didSet {
        phoneNumberLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
    }}
    
    @IBOutlet weak var isMainLabel: UILabel!{ didSet {
        isMainLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
    }}
    
    
    static let identifier = "PhoneNumberCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
