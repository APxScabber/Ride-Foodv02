import UIKit

class PromotionsTableViewController: UITableViewController {

    @IBOutlet weak var foodLabel: UILabel! { didSet {
        foodLabel.text = PromotionConstant.food
    }}
    @IBOutlet weak var taxiLabel: UILabel! { didSet {
        taxiLabel.text = PromotionConstant.taxi
    }}
    @IBAction func dismiss(_ sender:UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    private var promotionType: [PromotionsFetcher.PromotionType] = [.food,.taxi]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = PromotionConstant.promotion
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "promotionList",
           let destination = segue.destination as? PromotionListTableViewController,
           let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {            
            destination.promotionType = promotionType[indexPath.row]
        }
    }
}
