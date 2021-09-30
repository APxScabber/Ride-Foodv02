//
//  CancelOrderVC.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 27.09.2021.
//

import UIKit

protocol CancelOrderDelegate: AnyObject{
    func confirmCancel()
}

class CancelOrderVC: UIViewController {
    
    weak var delegate: CancelOrderDelegate?
    
    let reasons = [
        Localizable.DriverSearch.changePlan.localized,
        Localizable.DriverSearch.orderMistake.localized,
        Localizable.DriverSearch.longWaiting.localized,
        Localizable.DriverSearch.noReasonCancel.localized
    ]
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var cancelOrderReasonLabel: UILabel! { didSet {
        cancelOrderReasonLabel.font = UIFont.SFUIDisplaySemibold(size: 17.0)
        cancelOrderReasonLabel.text = Localizable.DriverSearch.cancelOrderReason.localized
    }}
    
    @IBOutlet weak var cancelOrderTableView: UITableView!
    
//    @IBOutlet weak var smallScrollView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
 
    
    func configureUI(){
        cancelOrderTableView.reloadData()
        containerView.layer.cornerRadius = 15
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CancelOrderVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cancelCell", for: indexPath) as! CancelOrderTableViewCell
        let reason = reasons[indexPath.row]
        cell.titleLabel.text = reason
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      dismiss(animated: true)
        delegate?.confirmCancel()
    }
    
    
}


