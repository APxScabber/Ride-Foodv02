import UIKit

class LanguageSelectionTableViewController: SettingsTableViewController {

   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //logic
        dismiss(animated: true)
    }

}
