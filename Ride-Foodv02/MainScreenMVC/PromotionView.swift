import UIKit

class PromotionView: UIView {

    @IBOutlet weak var detailLabel: UILabel! { didSet {
        detailLabel.font = UIFont.SFUIDisplaySemibold(size: 12.0)
    }}
    
    @IBAction func close(_ sender: UIButton) {
        removeFromSuperview()
    }

}
