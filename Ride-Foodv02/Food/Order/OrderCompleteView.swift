import UIKit

protocol OrderCompleteViewDelegate: AnyObject {
    func orderCompleteViewClose()
}

class OrderCompleteView: UIView {

    //MARK: - API
    
    weak var delegate: OrderCompleteViewDelegate?
    
    var totalPrice = 0 { didSet {
        priceLabel?.text = "\(totalPrice) " + Localizable.FoodOrder.foodOrderMoney.localized
    }}
    
    //MARK: - Outlets
    
    @IBOutlet weak var congratsLabel: UILabel! { didSet {
        congratsLabel.font = UIFont.SFUIDisplaySemibold(size: 17.0)
    }}
    
    @IBOutlet weak var descLabel: UILabel! { didSet {
        descLabel.font = UIFont.SFUIDisplayLight(size: 17.0)
    }}
    
    @IBOutlet weak var dateLabel: UILabel! { didSet {
        dateLabel.font = UIFont.SFUIDisplayRegular(size: 10.0)
    }}
    
    @IBOutlet weak var deliveryLabel: UILabel! { didSet {
        deliveryLabel.font = UIFont.SFUIDisplayRegular(size: 10.0)
    }}
    
    @IBOutlet weak var priceLabel: UILabel! { didSet {
        priceLabel.font = UIFont.SFUIDisplayRegular(size: 17.0)
    }}
    
    @IBOutlet weak var paymentImageView: UIImageView!
    @IBOutlet weak var paymentLabel: UILabel! { didSet {
        paymentLabel.font = UIFont.SFUIDisplayRegular(size: 17.0)
    }}
    
    @IBOutlet weak var paymentDetailLabel: UILabel! { didSet {
        paymentDetailLabel.font = UIFont.SFUIDisplayRegular(size: 8.0)
    }}
    
    @IBOutlet weak var bottomRoundedView: RoundedView! { didSet {
        bottomRoundedView.cornerRadius = 15.0
        bottomRoundedView.colorToFill = #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
    }}
    
    @IBOutlet weak var newOrderButton: UIButton! { didSet {
        newOrderButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17.0)
    }}

    @IBOutlet weak var schrinkableView: UIView!
    @IBOutlet weak var schrinkableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Action
    
    @IBAction func newOrder(_ sender: UIButton) {
        close()
    }
    
    //MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        congratsLabel.text = Localizable.FoodOrder.foodOrderCongrats.localized
        descLabel.text = Localizable.FoodOrder.foodOrderSeeYouAgain.localized
        priceLabel.text = "\(totalPrice) " + Localizable.FoodOrder.foodOrderMoney.localized
        deliveryLabel.text = " / \(Localizable.FoodOrder.foodOrderDeliveryFood.localized)"
        paymentLabel.text = Localizable.FoodOrder.foodOrderPayment.localized
        newOrderButton.setTitle(Localizable.FoodOrder.foodOrderNewOrder.localized, for: .normal)
    }
    
    
    //MARK: - Init
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown(_:)))
        swipe.direction = .down
        addGestureRecognizer(swipe)
    }
    
    @objc private func swipeDown(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            if schrinkableViewHeightConstraint.constant != 0 {
                schrinkableView.isHidden = true
                totalHeightConstraint.constant -= schrinkableViewHeightConstraint.constant
                schrinkableViewHeightConstraint.constant = 0
                UIView.animate(withDuration: 0.25) {
                    self.layoutIfNeeded()
                }
            } else {
                close()
            }
        }
    }
    
    private func close() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveLinear) {
            self.frame.origin.y = self.superview?.frame.height ?? 0
        } completion: {  if $0 == .end {
            self.removeFromSuperview()
            self.delegate?.orderCompleteViewClose()
        }
        }

    }
    
    func reset() {
        schrinkableView.isHidden = false
        if schrinkableViewHeightConstraint.constant == 0 {
            schrinkableViewHeightConstraint.constant = 122.0
            totalHeightConstraint.constant += schrinkableViewHeightConstraint.constant
        }
    }
}
