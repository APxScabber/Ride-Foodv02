import UIKit

class PromotionsTableViewController: UITableViewController {

    @IBAction func dismiss(_ sender:UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.title = "Акции"
    }
}
