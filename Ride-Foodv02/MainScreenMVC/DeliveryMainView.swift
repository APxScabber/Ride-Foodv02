import UIKit

protocol DeliveryMainViewDelegate: AnyObject {
    func deliveryMainViewClose()
}

class DeliveryMainView: UIView {

    //MARK: - API
    weak var delegate: DeliveryMainViewDelegate?
    
    //MARK: - Outlets
    
    @IBOutlet weak var deliveryLabel: UILabel! { didSet {
        deliveryLabel.font = UIFont.SFUIDisplayRegular(size: 17.0)
    }}
    
    @IBOutlet weak var timeLabel: UILabel! { didSet {
        timeLabel.font = UIFont.SFUIDisplayRegular(size: 17.0)
    }}
    
    @IBOutlet weak var roundedView: RoundedView! { didSet {
        roundedView.cornerRadius = 15.0
        roundedView.colorToFill = .white
    }}
    //MARK: - Action
    
    @IBAction func close(_ sender: UIButton) {
        delegate?.deliveryMainViewClose()
    }

    //MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        deliveryLabel.text = Localizable.Delivery.deliveryTime.localized
        timeLabel.text = " ≈ 30 \(Localizable.Delivery.deliveryMin.localized)"
    }
}
