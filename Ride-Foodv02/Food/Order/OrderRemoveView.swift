import UIKit

protocol OrderRemoveViewDelegate: AnyObject {
    func orderRemoveViewClear()
    func orderRemoveViewCancel()
}

class OrderRemoveView: UIView {

    //MARK: - API

    weak var delegate: OrderRemoveViewDelegate?
    
    //MARK: - Outlets
    
    @IBOutlet weak var messageLabel: UILabel! { didSet {
        messageLabel.font = UIFont.SFUIDisplayRegular(size: 17.0)
        messageLabel.text = Localizable.OrderRemove.orderRemoveTitle.localized
    }}
    
    @IBOutlet weak var roundedView: RoundedView! { didSet {
        roundedView.cornerRadius = 15.0
        roundedView.colorToFill = #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
    }}
    
    @IBOutlet weak var removeButton: UIButton! { didSet {
        removeButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17.0)
        removeButton.setTitle(Localizable.OrderRemove.orderRemoveClear.localized, for: .normal)
    }}
    
    @IBOutlet weak var cancelButton: UIButton! { didSet {
        cancelButton.titleLabel?.font = UIFont.SFUIDisplayLight(size: 17.0)
        cancelButton.setTitle(Localizable.OrderRemove.orderRemoveCancel.localized, for: .normal)
    }}
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint! { didSet {
        heightConstraint.constant = CGFloat(220.0 + SafeArea.shared.bottom)
    }}
    
    //MARK: - Actions
    
    @IBAction func clear(_ sender:UIButton) {
        delegate?.orderRemoveViewClear()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        delegate?.orderRemoveViewCancel()
    }
    
    
    //MARK: - UI logic
    
    func show() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
            self.frame.origin.y = self.superview!.frame.height - CGFloat(220.0 + SafeArea.shared.bottom)
        }
    }
    
    func close() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
            self.frame.origin.y = self.superview!.frame.height
        }
    }
    
    
}
