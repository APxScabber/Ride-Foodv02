import UIKit

class OrderHistoryTableViewCell: UITableViewCell {

    var orderHistoryState: OrderHistoryState = .done { didSet { updateUI() }}
    
    @IBOutlet weak var topRoundedView: RoundedView! { didSet {
        topRoundedView.cornerRadius = 15.0
        topRoundedView.colorToFill = .white
    }}
    @IBOutlet weak var topRoundedViewHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var bottomRoundedView: UIView! { didSet {
//
//    }}
    
    
    private func updateUI() {
        topRoundedViewHeightConstraint.constant = orderHistoryState == .done ? 120 : 150
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
            self.layoutIfNeeded()
        } completion: { if $0 == .end {}
        }

        
    }
    
    
    enum OrderHistoryState {
        case done
        case cancel
    }
}
