import UIKit

protocol ShopDetailViewDelegate: AnyObject {
    func close()
}

class ShopDetailView: UIView {

    weak var delegate: ShopDetailViewDelegate?
    
    @IBOutlet weak var titleLabel: UILabel! { didSet {
        titleLabel.font = UIFont.SFUIDisplaySemibold(size: 15.0)
    }}
    
    @IBOutlet weak var addressLabel: UILabel! { didSet {
        addressLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
    }}
    
    @IBOutlet weak var scheduleLabel: UILabel! { didSet {
        scheduleLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    
    @IBOutlet weak var menuLabel: UILabel! { didSet {
        menuLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
    }}
    
    @IBOutlet weak var descriptionLabel: UILabel! { didSet {
        descriptionLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    
    @IBAction func close(_ sender: UIButton) {
        delegate?.close()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        layer.cornerRadius = 15.0
        layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
}
