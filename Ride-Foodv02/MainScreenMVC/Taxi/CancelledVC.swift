//
//  CancelledVC.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 27.09.2021.
//

import UIKit

protocol CancelOrderActionsProtocol: AnyObject{
    func closeScreen()
    func newOrder()
    func reportProblem()
}

class CancelledVC: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var orderCancelLabel: UILabel! { didSet {
        orderCancelLabel.font = UIFont.SFUIDisplaySemibold(size: 15.0)
        orderCancelLabel.text = Localizable.DriverSearch.cancelOrder.localized
    }}
    
    @IBOutlet weak var sadFaceImageView: UIImageView!
    
    @IBOutlet weak var cancelTitleLabel: UILabel! { didSet{
        cancelTitleLabel.textColor = UIColor.saleOrangeColor
        cancelTitleLabel.font = UIFont.SFUIDisplaySemibold(size: 17.0)
        cancelTitleLabel.text = Localizable.DriverSearch.youCanceledOrder.localized
    }}
    
    @IBOutlet weak var cancelDescriptionLabel: UILabel! { didSet {
        cancelDescriptionLabel.font = UIFont.SFUIDisplayLight(size: 17.0)
        cancelDescriptionLabel.text = Localizable.DriverSearch.cancelOrderDescription.localized
    }}
    
    @IBOutlet weak var anotherOrderButton: UIButton! { didSet{
        anotherOrderButton.layer.cornerRadius = 15
        anotherOrderButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17.0)
        anotherOrderButton.setTitle(Localizable.DriverSearch.newOrder.localized, for: .normal)
    }}
    
    @IBOutlet weak var reportProblemButton: UIButton! { didSet {
        reportProblemButton.titleLabel?.font = UIFont.SFUIDisplayLight(size: 17.0)
        reportProblemButton.setTitle(Localizable.DriverSearch.reportProblem.localized, for: .normal)
    }}
    
    weak var delegate: CancelOrderActionsProtocol?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.closeScreen()
    }
    
    @IBAction func anotherOrder(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.newOrder()
    }
    
    @IBAction func reportProblem(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.reportProblem()
     
        
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
