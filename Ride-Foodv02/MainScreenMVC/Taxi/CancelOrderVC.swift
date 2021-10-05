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
    
    //MARK: - API
    weak var delegate: CancelOrderDelegate?
    
    let reasons = [
        Localizable.DriverSearch.changePlan.localized,
        Localizable.DriverSearch.orderMistake.localized,
        Localizable.DriverSearch.longWaiting.localized,
        Localizable.DriverSearch.noReasonCancel.localized
    ]
    
    //MARK: - Outlets
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var cancelOrderReasonLabel: UILabel! { didSet {
        cancelOrderReasonLabel.font = UIFont.SFUIDisplaySemibold(size: 17.0)
        cancelOrderReasonLabel.text = Localizable.DriverSearch.cancelOrderReason.localized
    }}
    
    @IBOutlet weak var cancelOrderTableView: UITableView!
    
    
    //MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
 
    //MARK: - UI logic
    
    func configureUI(){
        cancelOrderTableView.reloadData()
        containerView.layer.cornerRadius = 15
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }



}
//MARK: - UITableViewDelegate, UITableViewDataSource

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


