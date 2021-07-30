//
//  MyAddressesTableViewCell.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 21.07.2021.
//

import UIKit

class MyAddressesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var AddressTitleLabel: UILabel!
    
    @IBOutlet weak var fullAddressLabel: UILabel!
    
    @IBOutlet weak var houseImageView: UIImageView!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCells(address: UserAddressMO){
        self.AddressTitleLabel.text = address.title
        self.fullAddressLabel.text = address.fullAddress
        self.fullAddressLabel.textColor = UIColor.DarkGrayTextColor
        
    }
    
}
