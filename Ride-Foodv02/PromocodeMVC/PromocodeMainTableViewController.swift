import UIKit

class PromocodeMainTableViewController: UITableViewController {


    @IBOutlet weak var enterPromocodeLabel: SettingsMainLabel! { didSet {
        enterPromocodeLabel.text = Localizable.Promocode.enterPromocode.localized
    }}
    
    @IBOutlet weak var usageHistoryLabel: SettingsMainLabel! { didSet {
        usageHistoryLabel.text = Localizable.Promocode.historyUsage.localized
    }}
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Localizable.Promocode.promocode.localized
    }

}
