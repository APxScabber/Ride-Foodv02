import UIKit

class PersonalInfoTableViewController: UITableViewController {

    @IBOutlet var cells: [UITableViewCell]!
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.title = "Персональные данные"
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 { return SettingsHeaderView.createWith(SettingsConstant.name, in: self.view)}
        if section == 2 { return SettingsHeaderView.createWith(SettingsConstant.email, in: self.view)}
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.backgroundColor = .SettingsBackgroundColor
        cells.forEach { $0.backgroundColor = .SettingsBackgroundColor }
    }
    
}
