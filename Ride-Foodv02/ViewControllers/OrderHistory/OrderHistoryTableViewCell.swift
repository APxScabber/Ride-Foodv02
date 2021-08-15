import UIKit

class OrderHistoryTableViewCell: UITableViewCell {

    var orderHistoryState: OrderHistoryState = .done { didSet { updateUI() }}
    
    @IBOutlet weak var topRoundedView: UIView!
    @IBOutlet weak var topRoundedViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomRoundedView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel! { didSet {
        dateLabel.font = UIFont.SFUIDisplayRegular(size: 10.0)
    }}
    
    @IBOutlet weak var orderTypeDetailLabel: UILabel! { didSet {
        orderTypeDetailLabel.font = UIFont.SFUIDisplayRegular(size: 10.0)
    }}
    
    @IBOutlet weak var orderTypeLabel: UILabel! { didSet {
        orderTypeLabel.font = UIFont.SFUIDisplayRegular(size: 17.0)
    }}
    
    @IBOutlet weak var priceLabel: UILabel! { didSet {
        priceLabel.font = UIFont.SFUIDisplayRegular(size: 17.0)
    }}
    
    @IBOutlet weak var orderImageView: UIImageView!
    
    @IBOutlet weak var cancelReasonLabel: UILabel! { didSet {
        cancelReasonLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
        cancelReasonLabel.text = Localizable.OrderHistory.cancelReason.localized
    }}
    
    @IBOutlet weak var cancelReasonDescLabel: UILabel! { didSet {
        cancelReasonDescLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    
    private func updateUI() {
        topRoundedView.layer.backgroundColor = UIColor.white.cgColor
        topRoundedView.layer.cornerRadius = 15.0
        
        bottomRoundedView.layer.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1).cgColor
        bottomRoundedView.layer.cornerRadius = 15.0
        
        if orderHistoryState == .cancel {
            topRoundedView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            bottomRoundedView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        } else {
            topRoundedView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner,.layerMinXMaxYCorner]

        }
        
    }
    
    func updateViews() {
        
        topRoundedView.layer.backgroundColor = UIColor.white.cgColor
        topRoundedView.layer.cornerRadius = 15.0
        topRoundedView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]

    }
    
    enum OrderHistoryState {
        case done
        case cancel
    }

    
}
