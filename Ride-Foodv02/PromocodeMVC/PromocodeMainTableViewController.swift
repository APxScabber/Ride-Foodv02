import UIKit

class PromocodeMainTableViewController: UITableViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var enterPromocodeLabel: SettingsMainLabel! { didSet {
        enterPromocodeLabel.text = Localizable.Promocode.enterPromocode.localized
    }}
    
    @IBOutlet weak var usageHistoryLabel: SettingsMainLabel! { didSet {
        usageHistoryLabel.text = Localizable.Promocode.historyUsage.localized
    }}
    
    //MARK: - Actions
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    //MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Localizable.Promocode.promocode.localized
    }

}
