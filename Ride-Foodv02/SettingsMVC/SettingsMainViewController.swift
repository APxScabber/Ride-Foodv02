import UIKit

class SettingsMainViewController: SettingsTableViewController {

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            return SettingsHeaderView.createWith(SettingsConstant.locationUpdateMessage, in: self.view)
        }
        return nil
    }
    
    
    
}
