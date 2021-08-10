import UIKit

class PromotionsTableViewController: UITableViewController {

    //MARK: - API
    
    var shouldDismiss = true
    private var promotionType: [PromotionsFetcher.PromotionType] = [.food,.taxi]

    //MARK: - Outlets
    @IBOutlet weak var foodLabel: UILabel! { didSet {
        foodLabel.text = Localizable.Promotion.food.localized
    }}
    @IBOutlet weak var taxiLabel: UILabel! { didSet {
        taxiLabel.text = Localizable.Promotion.taxi.localized
    }}
    
    //MARK: - Actions
    
    @IBAction func dismiss(_ sender:UIBarButtonItem) {
        if shouldDismiss {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - Segue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Localizable.Promotion.promotion.localized
    }
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "promotionList",
           let destination = segue.destination as? PromotionListTableViewController,
           let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {            
            destination.promotionType = promotionType[indexPath.row]
        }
    }
}
