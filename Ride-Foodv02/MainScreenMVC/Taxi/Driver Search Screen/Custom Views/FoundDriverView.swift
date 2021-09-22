//
//  FoundDriverView.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 22.09.2021.
//

import UIKit

class FoundDriverView: UIView {

    @IBOutlet weak var confirmButton: UIButton! { didSet{
        confirmButton.layer.cornerRadius        = 15
        confirmButton.titleLabel?.font          = UIFont.SFUIDisplayRegular(size: 17)
    }}
    
    @IBOutlet weak var DriverInfoBackgroundView: UIView! { didSet{
        DriverInfoBackgroundView.backgroundColor = UIColor.SeparatorColor
    }}
    
    @IBOutlet weak var carNameAndColor: UILabel! {didSet{
        carNameAndColor.font                     = UIFont.SFUIDisplayRegular(size: 26)
    }}
    
    @IBOutlet weak var tariffBackgroundView: UIView!{didSet{
        tariffBackgroundView.layer.backgroundColor  = UIColor(red: 0.626, green: 0.883, blue: 0.298, alpha: 1).cgColor
        tariffBackgroundView.layer.cornerRadius     = 14
    }}
    
    @IBOutlet weak var tariffLabel: UILabel! {didSet{
        tariffLabel.font                           = UIFont.SFUIDisplayRegular(size: 10)
        tariffLabel.textColor                      = .white
    }}
    
    @IBOutlet weak var carImageView: UIImageView!
    
    @IBOutlet weak var driverTitleLabel: UILabel! {didSet{
        driverTitleLabel.textColor  = UIColor.DarkGrayTextColor
        driverTitleLabel.font       = UIFont.SFUIDisplayRegular(size: 14)
    }}
    
    @IBOutlet weak var driveTimeTitleLabel: UILabel! { didSet{
        driveTimeTitleLabel.textColor  = UIColor.DarkGrayTextColor
        driveTimeTitleLabel.font       = UIFont.SFUIDisplayRegular(size: 14)
    }}
    
    @IBOutlet weak var priceLabel: UILabel! { didSet{
        priceLabel.font             = UIFont.SFUIDisplayRegular(size: 18)
        priceLabel.textColor        = .black
    }}
    
    @IBOutlet weak var driverNemaLabel: UILabel! {didSet{
        driverNemaLabel.textColor  = UIColor.black
        driverNemaLabel.font       = UIFont.SFUIDisplayRegular(size: 14)
    }}
    
    @IBOutlet weak var driveTimeLabel: UILabel! {didSet{
        driveTimeLabel.textColor  = UIColor.black
        driveTimeLabel.font       = UIFont.SFUIDisplayRegular(size: 14)
    }}
    
    @IBOutlet weak var activeOrderImageView: UIImageView!
    
    @IBOutlet weak var activeOrderTimeLabel: UILabel! { didSet{
        activeOrderTimeLabel.font       = UIFont.SFUIDisplaySemibold(size: 17)
        activeOrderTimeLabel.textColor  = UIColor.white
    }}
    
    @IBOutlet weak var fromAddressLabel: UILabel! {didSet{
        fromAddressLabel.font = UIFont.SFUIDisplayRegular(size: 18)
        fromAddressLabel.textColor = UIColor.DarkGrayTextColor
    }}
    
    @IBOutlet weak var toAddressLabel: UILabel! {didSet{
        toAddressLabel.font = UIFont.SFUIDisplayRegular(size: 18)
        toAddressLabel.textColor = UIColor.DarkGrayTextColor
    }}
    
    
 

    @IBAction func confirm(_ sender: Any) {
    }
    
}
