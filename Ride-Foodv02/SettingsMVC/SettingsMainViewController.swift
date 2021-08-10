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
            return createWith(Localizable.Settings.automaticUpdateMessage.localized, in: self.view)
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - UpdateUI()
    
    private func updateUI() {
        navigationItem.title = Localizable.Settings.settings.localized
        languageLabel.text = Localizable.Settings.language.localized
        languageChosenLabel.text = Localizable.Settings.languageChosen.localized
        personalInfoLabel.text = Localizable.Settings.personalInfo.localized
        pushNotificationLabel.text = Localizable.Settings.pushNotification.localized
        promotionsLabel.text = Localizable.Settings.promotionsNotification.localized
        promotionsAvailableLabel.text = Localizable.Settings.promotionsAvailable.localized
        cellularLabel.text = Localizable.Settings.locationUpdateMessage.localized
    }
    
    private func createWith(_ text:String, in view:UIView) -> UIView {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50))
        let label = UILabel(frame: CGRect(x: 25, y: 0, width: view.bounds.width - 25, height: 14))
        var attributes = [NSAttributedString.Key:Any]()
        attributes[.font] = UIFont.SFUIDisplayRegular(size:12)
        attributes[.foregroundColor] = UIColor.SettingsHeaderColor
        let attString = NSAttributedString(string: text,attributes: attributes)
        label.attributedText = attString
        customView.addSubview(label)
        return customView
    }
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "promotionSegue",
           let destination = segue.destination as? PromotionsTableViewController {
            destination.shouldDismiss = false
        }
    }
}
