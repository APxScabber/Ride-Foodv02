//
//  PaymentHistoryColor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 12.08.2021.
//

import Foundation
import UIKit

enum PaymentHistoryColors {
    case blueColor
    case grayColor
}

extension PaymentHistoryColors {
    var value: UIColor {
        get {
            switch self {
            case .blueColor:
                return UIColor(red: 61/255, green: 59/255, blue: 255/255, alpha: 1)
            case .grayColor:
                return UIColor(red: 138/255, green: 138/255, blue: 141/255, alpha: 1)
            }
        }
    }
}
