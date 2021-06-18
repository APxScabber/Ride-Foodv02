import UIKit

class LanguageSelectionTableViewController: UITableViewController {
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet var images:[UIImageView]!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        Settings.shared.language = indexPath.row == 0 ? "ru" : "en"
        Settings.shared.languageID = indexPath.row
        updateUI()
    }

    private func updateUI() {
        navigationItem.title =  SettingsConstant.settings
        images.forEach { $0.image = UIImage(named: "EmptyDot")}
        images[Settings.shared.languageID].image = UIImage(named: "Checkmark")
    }
    
}
