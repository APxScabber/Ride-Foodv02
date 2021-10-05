import UIKit

protocol PromotionViewDelegate: AnyObject {
    func show()
    func closePromotionView()
}

class PromotionView: UIView {
    
    //MARK: - API
    weak var delegate: PromotionViewDelegate?
    
    //MARK: - Outlets
    
    @IBOutlet weak var detailLabel: UILabel! { didSet {
        detailLabel.font = UIFont.SFUIDisplaySemibold(size: 12.0)
    }}
    
    @IBOutlet weak var touchableView: UIView! { didSet {
        touchableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPromotion)))
    }}
    
    //MARK: - Actions
    
    @IBAction func close(_ sender: UIButton) {
        delegate?.closePromotionView()
        frame.size = .zero
        removeFromSuperview()
    }

    @objc
    private func showPromotion() {
        delegate?.show()
    }
}
