//
//  PaymentHistoryBigViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 09.08.2021.
//

import UIKit



class PaymentHistoryBigViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var testBigLabel: UILabel!
    
    var data: CellData?
    var delegate: ReloadDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(mainView.frame.origin.y)
        mainView.frame.origin.y = 0
        print(mainView.frame.origin.y)
        testBigLabel.text = data?.title
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.reloadTableView()
    }

}
