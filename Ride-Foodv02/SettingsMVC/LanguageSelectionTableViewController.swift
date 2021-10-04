import UIKit

class LanguageSelectionTableViewController: UITableViewController {
    
    //MARK: - Outlets
    
    @IBOutlet var images:[UIImageView]!

    //MARK: - Action
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - ViewController lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
   
    //MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        UserDefaultsManager.shared.userLanguage = indexPath.row == 0 ? UserDefaultsModel(language: "rus") : UserDefaultsModel(language: "eng")
        Settings.shared.language = indexPath.row == 0 ? "ru" : "en"
        Settings.shared.languageID = indexPath.row
        updateUI()
    }

    //MARK: - UIUpdate
    
    private func updateUI() {
        navigationItem.title =  Localizable.Settings.settings.localized
        images.forEach { $0.image = UIImage(named: "EmptyDot")}
        images[Settings.shared.languageID].image = UIImage(named: "Checkmark")
    }
    
}
