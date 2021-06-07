//
//  ColorElements.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.06.2021.
//

import Foundation
import UIKit

enum ColorElements {
    case blackTextColor
    case buttonEnableColor
    case buttonDisableColor
    case grayTextColor
}

extension ColorElements {
    var value: UIColor {
        get {
            switch self {
            case .blackTextColor:
                return UIColor.black
            case .buttonEnableColor:
                return UIColor(red: 61/255, green: 59/255, blue: 255/255, alpha: 1)
            case .buttonDisableColor:
                return UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1)
            case .grayTextColor:
                return UIColor.gray
            }
        }
    }
}
