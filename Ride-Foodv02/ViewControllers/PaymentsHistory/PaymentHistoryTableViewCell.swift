//
//  PaymentHistoryTableViewCell.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 08.08.2021.
//

import UIKit

class PaymentHistoryTableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var testTextLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

struct CellData {
    let title: String
}
