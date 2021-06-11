import UIKit

class LanguageSelectionTableViewController: UITableViewController {
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.title = "Язык"
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //logic
        dismiss(animated: true)
    }

}
