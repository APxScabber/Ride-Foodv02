//
//  CarNumberView.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 23.09.2021.
//

import UIKit

class CarNumberView: UIView {

    //MARK: - Outlets
    
    @IBOutlet weak var carNumberLabel: UILabel! {didSet{
        carNumberLabel.font             = UIFont.SFUIDisplayRegular(size: 12)
        carNumberLabel.textColor        = UIColor.black
    }}
    
    @IBOutlet weak var carRegionNumber: UILabel! { didSet{
        carRegionNumber.font            = UIFont.SFUIDisplayRegular(size: 8)
        carRegionNumber.textColor       = UIColor.DarkGrayTextColor
    }}
    
    @IBOutlet weak var regionImageView: UIImageView!
    
    
}
