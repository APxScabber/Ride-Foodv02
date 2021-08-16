import UIKit

class OrderHistoryVC: UIViewController {

   //MARK: - Outlets
    @IBOutlet weak var label: UILabel! { didSet {
        label.font = UIFont.SFUIDisplayRegular(size: 26.0)
    }}
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl! { didSet {
        guard let font = UIFont.SFUIDisplayRegular(size: 15.0) else { return }
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        segmentedControl.setTitle(Localizable.OrderHistory.done.localized, forSegmentAt: 0)
        segmentedControl.setTitle(Localizable.OrderHistory.canceled.localized, forSegmentAt: 1)
    }}
    
    //MARK: - Actions
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func changeOrderType(_ sender: UISegmentedControl) {
        tableView.beginUpdates()
        tableView.visibleCells.forEach {
            if let orderHistoryCell = $0 as? OrderHistoryTableViewCell {
                orderHistoryCell.updateViews()
            }
        }
        tableView.endUpdates()
        perform(#selector(update), with: nil, afterDelay: 0.25)
    }
    
    //MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Localizable.OrderHistory.history.localized
    }
    
    //MARK: - Reload data
    @objc
    private func update() {
        tableView.reloadData()
    }
}

//MARK: - UItableview datasourse


extension OrderHistoryVC: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryCell", for: indexPath)
        
        if let orderHistoryCell = cell as? OrderHistoryTableViewCell {
            orderHistoryCell.orderHistoryState = segmentedControl.selectedSegmentIndex == 0 ? .done : .cancel
            return orderHistoryCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return segmentedControl.selectedSegmentIndex == 0 ? 120 : 150
    }
    
}
