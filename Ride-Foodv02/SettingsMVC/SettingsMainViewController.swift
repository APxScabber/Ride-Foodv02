import UIKit

class SettingsMainViewController: UITableViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var languageLabel: SettingsMainLabel!
    @IBOutlet weak var languageChosenLabel: SettingsMainLabel!
    @IBOutlet weak var personalInfoLabel: SettingsMainLabel!
    @IBOutlet weak var pushNotificationLabel: SettingsMainLabel!
    @IBOutlet weak var promotionsLabel: SettingsMainLabel!
    @IBOutlet weak var promotionsAvailableLabel: SettingsMainLabel!
    @IBOutlet weak var cellularLabel: SettingsMainLabel!
    
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
        dismiss(animated: true)
    }
    
    //MARK: - ViewController lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        tableView.reloadData()
    }
    
    //MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            return SettingsHeaderView.createWith(SettingsConstant.automaticUpdateMessage, in: self.view)
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - UpdateUI()
    
    private func updateUI() {
        navigationItem.title = SettingsConstant.settings
        languageLabel.text = SettingsConstant.language
        languageChosenLabel.text = SettingsConstant.languageChosen
        personalInfoLabel.text = SettingsConstant.personalInfo
        pushNotificationLabel.text = SettingsConstant.pushNotification
        promotionsLabel.text = SettingsConstant.promotionsNotification
        promotionsAvailableLabel.text = SettingsConstant.promotionsAvailable
        cellularLabel.text = SettingsConstant.locationUpdateMessage
    }
    
}
