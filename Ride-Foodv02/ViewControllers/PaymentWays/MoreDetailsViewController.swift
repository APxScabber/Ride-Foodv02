//
//  MoreDetailsViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 03.08.2021.
//

import UIKit

class MoreDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var startButtonOutlet: UIButton!
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - Methods
    
    private func setupUI() {
        
        titleLabel.font = UIFont.SFUIDisplayBold(size: 26)
        titleLabel.text = MoreDetailsViewText.topTitle.text()
        
        infoTextView.font = UIFont.SFUIDisplayRegular(size: 15)
        infoTextView.textColor = PaymentWaysColors.grayColor.value
        infoTextView.text = MoreDetailsViewText.infoText.text()
        
        startButtonOutlet.style()
        startButtonOutlet.backgroundColor = PaymentWaysColors.blueColor.value
        startButtonOutlet.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17)
        startButtonOutlet.setTitle(MoreDetailsViewText.buttonText.text(), for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func startButtonAction(_ sender: Any) {
       
    }
    
}
