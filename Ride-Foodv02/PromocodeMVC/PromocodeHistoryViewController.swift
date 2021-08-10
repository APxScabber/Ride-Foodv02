import UIKit

class PromocodeHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
 
    @IBOutlet weak var segmentedControl: UISegmentedControl! { didSet {
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        segmentedControl.setTitle(Localizable.Promocode.active.localized, forSegmentAt: 0)
        segmentedControl.setTitle(Localizable.Promocode.inactivate.localized, forSegmentAt: 1)
    }}

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoLabel: UILabel! { didSet {
        infoLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
        infoLabel.text = Localizable.Promocode.promocodeDescription.localized
    }}
    @IBOutlet private weak var tableViewTopConstraint: NSLayoutConstraint!
    
    var showActivePromocode: Bool { segmentedControl.selectedSegmentIndex == 0 }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Localizable.Promocode.historyUsage.localized
    }
    

    @IBAction func goBack(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return showActivePromocode ? Promocodes.active.count : Promocodes.inActive.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "promocodeCell", for: indexPath)
        if let promocodeCell = cell as? PromocodeTableViewCell {
            if showActivePromocode {
                promocodeCell.titleLabel.text = Promocodes.active[indexPath.section].title
                promocodeCell.descriptionLabel.text = Promocodes.active[indexPath.section].description
                promocodeCell.statusLabel.text = Promocodes.active[indexPath.section].statusDescription
                promocodeCell.backgroundImageView.image = #imageLiteral(resourceName: "ActivePromocode")
            } else {
                promocodeCell.titleLabel.text = Promocodes.inActive[indexPath.section].title
                promocodeCell.descriptionLabel.text = Promocodes.inActive[indexPath.section].description
                promocodeCell.statusLabel.text = Promocodes.inActive[indexPath.section].statusDescription
                switch Promocodes.inActive[indexPath.section].status {
                    case .activated: promocodeCell.backgroundImageView.image = #imageLiteral(resourceName: "UsedPromocode")
                    case .expired: promocodeCell.backgroundImageView.image = #imageLiteral(resourceName: "LostPromocode")
                    default: break
                }
            }
            return promocodeCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc
    private func segmentedControlChanged() {
        tableView.reloadData()
        infoLabel.isHidden = !(segmentedControl.selectedSegmentIndex == 0)
        tableViewTopConstraint.constant = segmentedControl.selectedSegmentIndex == 0 ? 67 : 0
    }
    
}
