//
//  TariffsColor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 16.06.2021.
//

import Foundation
import UIKit

//Тут весь цвет использующийся в Tariffs ViewControllers
enum TariffsColors {
    case black
    case standartColor
    case premiumColor
    case businessColor
    case grayLabelColor
    case grayButtonColor
    case blueColor
}

extension TariffsColors {
    var value: UIColor {
        get {
            switch self {
            case .black:
                return .black
            case .standartColor:
                return UIColor(red: 153/255, green: 204/255, blue: 51/255, alpha: 1)
            case .grayLabelColor:
                return UIColor(red: 138/255, green: 138/255, blue: 141/255, alpha: 1)
            case .grayButtonColor:
                return UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1)
            case .premiumColor:
                return UIColor(red: 196/255, green: 66/255, blue: 242/255, alpha: 1)
            case .businessColor:
                return UIColor(red: 212/255, green: 189/255, blue: 128/255, alpha: 1)
            case .blueColor:
                return UIColor(red: 61/255, green: 59/255, blue: 255/255, alpha: 1)
            }
        }
    }
}
