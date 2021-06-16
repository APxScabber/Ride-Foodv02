//
//  ColorElements.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.06.2021.
//

import Foundation
import UIKit

//Тут весь цвет использующийся в Login и Confirm ViewControllers
enum LoginColors {
    case blackTextColor
    case blueColor
    case greyButtonColor
    case grayTextColor
    case grayLableColor
}

extension LoginColors {
    var value: UIColor {
        get {
            switch self {
            case .blackTextColor:
                return UIColor.black
            case .blueColor:
                return UIColor(red: 61/255, green: 59/255, blue: 255/255, alpha: 1)
            case .greyButtonColor:
                return UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1)
            case .grayTextColor:
                return UIColor.gray
            case .grayLableColor:
                return UIColor(red: 239/255, green: 239/255, blue: 240/255, alpha: 1)
            }
        }
    }
}
