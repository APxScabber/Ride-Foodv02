import UIKit

protocol PromotionDetailDelegate: AnyObject {
    func dismiss()
}

class PromotionDetail: UIView {

    //MARK: - API
    
    weak var delegate: PromotionDetailDelegate?
    
    //MARK: - Outlets
    
    @IBOutlet weak var buyButton: UIButton! { didSet {
        buyButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17)
        buyButton.setTitle(Localizable.Promotion.goShopping.localized, for: .normal)
        buyButton.layer.cornerRadius = 15.0
    }}
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var headerLabel: UILabel! { didSet {
        headerLabel.font = UIFont.SFUIDisplayBold(size: 26)
    }}
    @IBOutlet weak var descriptionLabel: UILabel! { didSet {
        descriptionLabel.font = UIFont.SFUIDisplayRegular(size: 15)
    }}
    @IBOutlet weak var errorDescriptionLabel: UILabel! { didSet {
        errorDescriptionLabel.font = UIFont.SFUIDisplayRegular(size: 12)
        errorDescriptionLabel.isHidden = true
        errorDescriptionLabel.text = Localizable.Promotion.errorDescription.localized
    }}
    @IBOutlet weak var transparentView: UIView! { didSet {
        transparentView.alpha = 0.5
    }}
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    
    //MARK: - Action
    
    @IBAction func dismiss(_ sender: UIButton) {
        done()
    }
    
    @IBAction func buyButtonAction(_ sender: UIButton) {
        if errorDescriptionLabel.isHidden {
            errorDescriptionLabel.isHidden = false
            bottomConstraint.constant += errorDescriptionLabel.bounds.height + 9.0
        }
    }
    
    //MARK: - Dismiss
    @objc
    private func done() {
        bottomConstraint.constant = 10.0
        errorDescriptionLabel.isHidden = true
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0.0, options: .curveLinear) {
            self.frame.origin.y = self.superview?.bounds.height ?? 0
        }
        delegate?.dismiss()
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
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(done))
        swipe.direction = .down
        addGestureRecognizer(swipe)
    }
}
