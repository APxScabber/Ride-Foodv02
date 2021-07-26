import UIKit

protocol PromotionViewDelegate: AnyObject {
    func show()
}

class PromotionView: UIView {

    weak var delegate: PromotionViewDelegate?
    
    @IBOutlet weak var detailLabel: UILabel! { didSet {
        detailLabel.font = UIFont.SFUIDisplaySemibold(size: 12.0)
    }}
    
    @IBOutlet weak var touchableView: UIView! { didSet {
        touchableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPromotion)))
    }}
    
    @IBAction func close(_ sender: UIButton) {
        removeFromSuperview()
    }

    @objc
    private func showPromotion() {
        delegate?.show()
    }
    
}
