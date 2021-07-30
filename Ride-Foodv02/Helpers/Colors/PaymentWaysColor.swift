//
//  PaymentWaysColor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 06.07.2021.
//

import Foundation
import UIKit

//Тут весь цвет использующийся в PaymentWays ViewControllers

enum PaymentWaysColors {
    case grayColor
    case blueColor
    case yellowColor
}

extension PaymentWaysColors {
    var value: UIColor {
        get {
            switch self {
            case .grayColor:
                return UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1)
            case .blueColor:
                return UIColor(red: 61/255, green: 59/255, blue: 255/255, alpha: 1)
            case .yellowColor:
                return .systemYellow
            }
        }
    }
}
