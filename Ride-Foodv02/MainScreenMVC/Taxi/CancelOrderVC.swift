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
        "Поменялись планы",
        "Заказ совершен по ошибке",
        "Долгое ожидание заказа",
        "Без указания причины"
    ]
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var cancelOrderReasonLabel: UILabel!
    
    @IBOutlet weak var cancelOrderTableView: UITableView!
    
    @IBOutlet weak var smallScrollView: UIView!
    
    
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


