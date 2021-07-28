import UIKit

class PromocodeMainTableViewController: UITableViewController {


    @IBOutlet weak var enterPromocodeLabel: SettingsMainLabel! { didSet {
        enterPromocodeLabel.text = PromocodeConstant.enterPromocode
    }}
    
    @IBOutlet weak var usageHistoryLabel: SettingsMainLabel! { didSet {
        usageHistoryLabel.text = PromocodeConstant.historyUsage
    }}
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = PromocodeConstant.promocode
    }

}
