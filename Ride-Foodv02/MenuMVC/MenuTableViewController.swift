import UIKit

class MenuTableViewController: UITableViewController {

    //MARK: - Outlets
    @IBOutlet weak var menuLabel: UILabel! { didSet {
        menuLabel.font = UIFont.SFUIDisplaySemibold(size: 26)
    }}
    
    @IBOutlet weak var supportLabel: UILabel!
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var tariffsLabel: UILabel!
    @IBOutlet weak var promocodeLabel: UILabel!
    @IBOutlet weak var promotionLabel: UILabel!

    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    //MARK: - ViewController lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    private func updateUI() {
        menuLabel.text = MenuConstant.menu
        supportLabel.text = MenuConstant.support
        settingLabel.text = SettingsConstant.settings
        paymentMethodLabel.text = MenuConstant.paymentMethod
        tariffsLabel.text = MenuConstant.tariffs
        promocodeLabel.text = MenuConstant.promocode
        promotionLabel.text = MenuConstant.promotions
    }
    
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        
    }
    
}
