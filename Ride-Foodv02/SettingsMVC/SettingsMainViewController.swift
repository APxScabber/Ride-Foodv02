import UIKit

class SettingsMainViewController: UITableViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var pushNotificationSwitch: UISwitch! { didSet {
        pushNotificationSwitch.isOn = Settings.shared.shouldSendPush
    }}
    
    @IBOutlet weak var promotionsNotificationSwitch: UISwitch! { didSet {
        promotionsNotificationSwitch.isOn = Settings.shared.shouldNotifyPromotions
    }}
    
    @IBOutlet weak var shouldUpdateOnCellularSwitch: UISwitch! { didSet {
        shouldUpdateOnCellularSwitch.isOn = Settings.shared.shouldUpdateOnCellular
    }}
    
    //MARK: - IBActions
    
    @IBAction func shangePushNotificationSwitch(_ sender: UISwitch) {
        Settings.shared.shouldSendPush = sender.isOn
    }
    
    @IBAction func shangePromotionsNotificationSwitch(_ sender: UISwitch) {
        Settings.shared.shouldNotifyPromotions = sender.isOn
    }
    
    @IBAction func shangeShouldUpdateOnCellularSwitch(_ sender: UISwitch) {
        Settings.shared.shouldUpdateOnCellular = sender.isOn
    }
    //MARK: - IBActions
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.title = "Настройки"
    }
    
    //MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            return SettingsHeaderView.createWith(SettingsConstant.locationUpdateMessage, in: self.view)
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
