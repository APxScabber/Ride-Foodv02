//
//  TaxiOrderInfo.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 14.09.2021.
//

import UIKit

protocol TaxiOrderInfoDelegate: AnyObject {
    func problemAction()
    func addDelivery()
}

class TaxiOrderInfo: UIView {
    
    //MARK: - API
    weak var delegate: TaxiOrderInfoDelegate?
    
    //MARK: - Outlets
    
    @IBOutlet weak var swipeLineImageView: UIImageView!
    
    
    @IBOutlet weak var mainView: UIView! { didSet {
        mainView.layer.cornerRadius = 15
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        mainView.layoutIfNeeded()
    }}
    
    @IBOutlet weak var fromAddressTextField: UITextField! { didSet {
        fromAddressTextField.font = UIFont.SFUIDisplayRegular(size: 17.0)
    }}
    @IBOutlet weak var toAddressTextField: UITextField! { didSet {
        toAddressTextField.font = UIFont.SFUIDisplayRegular(size: 17.0)
    }}
    
    @IBOutlet weak var taxiTypeImageView: UIImageView!
    @IBOutlet weak var taxiInfoTimeTextView: UITextView!
    
    @IBOutlet weak var carModelLabel: UILabel! { didSet {
        carModelLabel.font = UIFont.SFUIDisplayRegular(size: 17.0)
        carModelLabel.alpha = 0
    }}
    @IBOutlet weak var carModelTopConstraint: NSLayoutConstraint! { didSet {
        carModelTopConstraint.constant = 0
    }}
    @IBOutlet weak var carModelHeightConstraint: NSLayoutConstraint! { didSet {
        carModelHeightConstraint.constant = 0
    }}
    
    @IBOutlet weak var mainCarNumberlabel: UILabel! { didSet {
        mainCarNumberlabel.font = UIFont.SFUIDisplayRegular(size: 17.0)
    }}
    @IBOutlet weak var carRegionNumberLabel: UILabel! { didSet {
        carRegionNumberLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    @IBOutlet weak var carNumberTopConstraint: NSLayoutConstraint! { didSet {
        carNumberTopConstraint.constant = 0
    }}
    @IBOutlet weak var carNumberHeightConstraint: NSLayoutConstraint! { didSet {
        carNumberHeightConstraint.constant = 0
    }}
    
    
    @IBOutlet weak var carNumberStackView: UIStackView! {didSet {
        carNumberStackView.alpha = 0
    }}
    @IBOutlet weak var carDriverTextView: UITextView! { didSet {
        carDriverTextView.font = UIFont.SFUIDisplayRegular(size: 15.0)
        carDriverTextView.textContainer.lineFragmentPadding = 0
        carDriverTextView.textContainerInset = .zero
        carDriverTextView.alpha = 0
        
    }}
    @IBOutlet weak var driverTopConstraint: NSLayoutConstraint! { didSet {
        driverTopConstraint.constant = 0
    }}
    @IBOutlet weak var driverHeightConstrint: NSLayoutConstraint! { didSet {
        driverHeightConstrint.constant = 0
    }}
    
    @IBOutlet weak var addDeliveryButtonOutlet: UIButton! { didSet {
        addDeliveryButtonOutlet.style()
        addDeliveryButtonOutlet.alpha = 0
    }}
    @IBOutlet weak var addDeliveryTopCostraint: NSLayoutConstraint! { didSet {
        addDeliveryTopCostraint.constant = 0
    }}
    @IBOutlet weak var addDeliveryHeightConstraint: NSLayoutConstraint! { didSet {
        addDeliveryHeightConstraint.constant = 0
    }}
    
    @IBOutlet weak var problemButtonOutlet: UIButton! { didSet {
        problemButtonOutlet.alpha = 0
    }}
    @IBOutlet weak var problemTopConstraint: NSLayoutConstraint! { didSet {
        problemTopConstraint.constant = 0
    }}
    @IBOutlet weak var problemHeightConstraint: NSLayoutConstraint! { didSet {
        problemHeightConstraint.constant = 0
    }}
    
    // MARK: - Actions
    
    @IBAction func problemButtonAction(_ sender: Any) {
        delegate?.problemAction()
    }
    
    @IBAction func addDeliveryButtonAction(_ sender: Any) {
        delegate?.addDelivery()
    }
    
    //MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        problemButtonOutlet.setTitle(Localizable.DriverSearch.reportProblem.localized, for: .normal)
        addDeliveryButtonOutlet.setTitle(Localizable.Delivery.deliveryAdd.localized, for: .normal)
    }
    
    
}
