import UIKit

class OrderHistoryVC: UIViewController {

   //MARK: - Outlets
    @IBOutlet weak var label: UILabel! { didSet {
        label.font = UIFont.SFUIDisplayRegular(size: 26.0)
    }}
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //MARK: - Actions
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func changeOrderType(_ sender: UISegmentedControl) {
        
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
    

    
}
