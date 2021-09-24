//
//  FoodOrderInfo.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 20.09.2021.
//

import UIKit

protocol FoodOrderInfoDelegate: AnyObject {
    func cancelOrder()
}

class FoodOrderInfo: UIView {
    
    weak var delegate: FoodOrderInfoDelegate?
    
    @IBOutlet weak var swipeLineImageView: UIImageView!
    
    
    @IBOutlet weak var mainView: UIView! { didSet {
        mainView.layer.cornerRadius = 15
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        mainView.layoutIfNeeded()
    }}
    
    @IBOutlet weak var deliveryFoodTextField: UITextField! { didSet {
        deliveryFoodTextField.font = UIFont.SFUIDisplayRegular(size: 17.0)
        //deliveryFoodTextField.textColor = UIColor(red: 138, green: 138, blue: 141, alpha: 1)
    }}
    @IBOutlet weak var toAddressTextField: UITextField! { didSet {
        toAddressTextField.font = UIFont.SFUIDisplayRegular(size: 17.0)
        //toAddressTextField.textColor = UIColor(red: 138, green: 138, blue: 141, alpha: 1)
    }}
    
    @IBOutlet weak var foodInfoTimeTextView: UITextView!
    
    @IBOutlet weak var courierTextView: UITextView! { didSet {
        courierTextView.font = UIFont.SFUIDisplayRegular(size: 15.0)
        courierTextView.textContainer.lineFragmentPadding = 0
        courierTextView.textContainerInset = .zero
        courierTextView.alpha = 0
        
    }}
    @IBOutlet weak var courierTopConstraint: NSLayoutConstraint! { didSet {
        courierTopConstraint.constant = 0
    }}
    @IBOutlet weak var courierHeightConstrint: NSLayoutConstraint! { didSet {
        courierHeightConstrint.constant = 0
    }}
    
    @IBOutlet weak var callButtonOutlet: UIButton! { didSet {
        callButtonOutlet.style()
        callButtonOutlet.alpha = 0
    }}
    @IBOutlet weak var callTopCostraint: NSLayoutConstraint! { didSet {
        callTopCostraint.constant = 0
    }}
    @IBOutlet weak var callHeightConstraint: NSLayoutConstraint! { didSet {
        callHeightConstraint.constant = 0
    }}
    
    @IBOutlet weak var cancelButtonOutlet: UIButton! { didSet {
        cancelButtonOutlet.alpha = 0
    }}
    @IBOutlet weak var cancelTopConstraint: NSLayoutConstraint! { didSet {
        cancelTopConstraint.constant = 0
    }}
    @IBOutlet weak var cancelHeightConstraint: NSLayoutConstraint! { didSet {
        cancelHeightConstraint.constant = 0
    }}
    
    // MARK: - Actions

    @IBAction func cancelOrderButtonAction(_ sender: Any) {
        delegate?.cancelOrder()
    }
    
}
