import UIKit

class FoodOrderCell: UITableViewCell {

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var paymentLabel: UILabel! { didSet {
        paymentLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
    }}
    
    @IBOutlet weak var lastFourCardDigitsLabel: UILabel! { didSet {
        lastFourCardDigitsLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
    }}

}
