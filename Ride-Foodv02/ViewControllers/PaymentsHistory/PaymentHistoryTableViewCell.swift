//
//  PaymentHistoryTableViewCell.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 08.08.2021.
//

import UIKit

class PaymentHistoryTableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var paymentNumberLabel: UILabel!
    //@IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
   // @IBOutlet weak var emailButtonOutlet: UIButton!
    
    @IBOutlet weak var bgImage: UIImageView!
    

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
