import UIKit

class PromocodeMainTableViewController: UITableViewController {


    @IBOutlet weak var enterPromocodeLabel: SettingsMainLabel! { didSet {
        
    }}
    
    @IBOutlet weak var usageHistoryLabel: SettingsMainLabel! { didSet {
        
    }}
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Промокод"
    }

}