import UIKit

protocol PromotionDetailDelegate: AnyObject {
    func dismiss()
}

class PromotionDetail: UIView {

    weak var delegate: PromotionDetailDelegate?
    
    @IBOutlet weak var buyButton: UIButton! { didSet {
        buyButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17)
        buyButton.setTitle(PromotionConstant.goShopping, for: .normal)
    }}
    @IBOutlet private weak var buyButtonView: RoundedView! { didSet {
        buyButtonView.colorToFill = .white
        buyButtonView.cornerRadius = 15.0
    }}
    @IBOutlet weak var imageView: UIImageView! { didSet {
        
    }}
    @IBOutlet weak var headerLabel: UILabel! { didSet {
        headerLabel.font = UIFont.SFUIDisplayBold(size: 26)
    }}
    @IBOutlet weak var descriptionLabel: UILabel! { didSet {
        descriptionLabel.font = UIFont.SFUIDisplayRegular(size: 15)
    }}
    @IBOutlet weak var errorDescriptionLabel: UILabel! { didSet {
        errorDescriptionLabel.font = UIFont.SFUIDisplayRegular(size: 12)
        errorDescriptionLabel.isHidden = true
        errorDescriptionLabel.text = PromotionConstant.errorDescription
    }}
    @IBOutlet weak var transparentView: UIView! { didSet {
        transparentView.alpha = 0.5
    }}
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    
    @IBAction func dismiss(_ sender: UIButton) {
        bottomConstraint.constant = 10.0
        errorDescriptionLabel.isHidden = true
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: PromotionConstant.durationForAppearingPromotionView, delay: 0.0, options: .curveLinear) {
            self.frame.origin.y += self.bounds.height
        }
        delegate?.dismiss()
    }
    
    @IBAction func buyButtonAction(_ sender: UIButton) {
        if errorDescriptionLabel.isHidden {
            errorDescriptionLabel.isHidden = false
            bottomConstraint.constant += errorDescriptionLabel.bounds.height + 9.0
        }
    }
    
}
