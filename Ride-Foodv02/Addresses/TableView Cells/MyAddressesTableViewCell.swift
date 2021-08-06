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
    
    func configureCells(address: AddressData){
        self.AddressTitleLabel.text = address.name
        self.fullAddressLabel.text = address.address
        self.fullAddressLabel.textColor = UIColor.DarkGrayTextColor
        
    }
    
}
