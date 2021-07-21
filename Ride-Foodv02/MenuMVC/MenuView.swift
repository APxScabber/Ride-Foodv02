import UIKit

protocol MenuViewDelegate: AnyObject {
    func close()
    func goToStoryboard(_ name:String)
}

class MenuView: UIView {

    weak var delegate: MenuViewDelegate?
    var isVisible = false
    
    @IBOutlet weak var menuLabel: UILabel! { didSet {
        menuLabel.font = UIFont.SFUIDisplaySemibold(size: 26.0)
    }}
    
    @IBOutlet weak var aboutAppLabel: UILabel! { didSet {
        aboutAppLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    
    @IBAction func close(_ sender: UIButton) {
        delegate?.close()
    }

    @IBAction func goToSupport(_ sender: UIButton) {
        delegate?.goToStoryboard("Support")
    }
    
    @IBAction func goToSettings(_ sender: UIButton) {
        delegate?.goToStoryboard("Settings")
    }
    
    @IBAction func goToPayment(_ sender: UIButton) {
    }
    
    @IBAction func goToTarrifs(_ sender: UIButton) {
        delegate?.goToStoryboard("Tariffs")
    }
    
    @IBAction func goToPromocode(_ sender: UIButton) {
        delegate?.goToStoryboard("Promocode")
    }
    
    @IBAction func goToPromotions(_ sender: UIButton) {
        delegate?.goToStoryboard("Promotion")
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
        layer.maskedCorners = [.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
    }
    
}
