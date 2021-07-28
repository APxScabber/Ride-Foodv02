import UIKit

protocol MenuViewDelegate: AnyObject {
    func close()
    func goToStoryboard(_ name:String)
}

class MenuView: UIView {

    //MARK: - API
    weak var delegate: MenuViewDelegate?
    var isVisible = false
  
    //MARK: - Outlets
    
    @IBOutlet weak var menuLabel: UILabel! { didSet {
        menuLabel.font = UIFont.SFUIDisplaySemibold(size: 26.0)
    }}
    @IBOutlet weak var supportLabel: SettingsMainLabel!
    @IBOutlet weak var settingsLabel: SettingsMainLabel!
    @IBOutlet weak var paymentWaysLabel: SettingsMainLabel!
    @IBOutlet weak var tariffsLabel: SettingsMainLabel!
    @IBOutlet weak var promocodeLabel: SettingsMainLabel!
    @IBOutlet weak var promotionLabel: SettingsMainLabel!
    @IBOutlet weak var aboutAppLabel: UILabel! { didSet {
        aboutAppLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    
    //MARK: - Actions
    
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
        delegate?.goToStoryboard("PaymentWays")
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
    
    //MARK: - Init
    
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
    
    //MARK: - UI update
    
    override func layoutSubviews() {
        super.layoutSubviews()
        menuLabel.text = MenuConstant.menu
        settingsLabel.text = MenuConstant.settings
        supportLabel.text = MenuConstant.support
        paymentWaysLabel.text = MenuConstant.paymentWays
        tariffsLabel.text = MenuConstant.tariffs
        promocodeLabel.text = MenuConstant.promocode
        promotionLabel.text = MenuConstant.promotions
        aboutAppLabel.text = MenuConstant.aboutThisApp
    }

}
