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
    case greenLabelColor
    case grayLabelColor
    case grayButtonColor
}

extension TariffsColors {
    var value: UIColor {
        get {
            switch self {
            case .black:
                return .black
            case .greenLabelColor:
                return UIColor(red: 153/255, green: 204/255, blue: 51/255, alpha: 1)
            case .grayLabelColor:
                return UIColor(red: 138/255, green: 138/255, blue: 141/255, alpha: 1)
            case .grayButtonColor:
                return UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1)
            }
        }
    }
}
