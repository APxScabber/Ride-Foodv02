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
    
    @IBOutlet weak var orderCancelLabel: UILabel!
    
    @IBOutlet weak var sadFaceImageView: UIImageView!
    
    @IBOutlet weak var cancelTitleLabel: UILabel! { didSet{
        cancelTitleLabel.textColor = UIColor.saleOrangeColor
    }}
    
    @IBOutlet weak var cancelDescriptionLabel: UILabel!
    
    @IBOutlet weak var anotherOrderButton: UIButton! { didSet{
        anotherOrderButton.layer.cornerRadius = 15
    }}
    
    @IBOutlet weak var reportProblemButton: UIButton!
    
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
