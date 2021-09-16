//
//  TaxiOrderInfo.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 14.09.2021.
//

import UIKit

class TaxiOrderInfo: UIView {
    
    @IBOutlet weak var mainView: UIView! { didSet {
        mainView.layer.cornerRadius = 15
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }}
    



}
