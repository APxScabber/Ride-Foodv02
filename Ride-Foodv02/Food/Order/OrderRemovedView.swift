import UIKit

protocol OrderRemovedViewDelegate: AnyObject {
    func returnToShopping()
}

class OrderRemovedView: UIView {
    //MARK: - API
    
    weak var delegate: OrderRemovedViewDelegate?
    
    //MARK: - Outlets
    
    @IBOutlet weak var emptyCartLabel: UILabel! { didSet {
        emptyCartLabel.font = UIFont.SFUIDisplayRegular(size: 17.0)
        emptyCartLabel.text = Localizable.OrderRemove.orderRemoveEmptyCart.localized
    }}
    
    @IBOutlet weak var returnToShopingRoundedView: RoundedView! { didSet {
        returnToShopingRoundedView.cornerRadius = 15.0
        returnToShopingRoundedView.colorToFill = #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
    }}
    
    @IBOutlet weak var returnToShopingButton: UIButton! { didSet {
        returnToShopingButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17.0)
        returnToShopingButton.setTitle(Localizable.OrderRemove.orderRemoveReturnToShopping.localized, for: .normal)
    }}

    @IBOutlet weak var heightConstraint: NSLayoutConstraint! { didSet {
        heightConstraint.constant = CGFloat(320.0 + SafeArea.shared.bottom)
    }}
    
    //MARK: - Actions
    
    @IBAction func returnToShopping(_ sender: UIButton) {
        close()
        delegate?.returnToShopping()
    }
    
    func show() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
            self.frame.origin.y = self.superview!.frame.height - CGFloat(320.0 + SafeArea.shared.bottom)
        }
    }
    
    private func close() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
            self.frame.origin.y = self.superview!.frame.height
        }
    }
    
}
