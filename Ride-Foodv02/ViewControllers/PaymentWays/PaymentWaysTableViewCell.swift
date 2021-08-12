//
//  PaymentWaysTableViewCell.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 04.07.2021.
//

import UIKit

class PaymentWaysTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var paymentTextLabel: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
