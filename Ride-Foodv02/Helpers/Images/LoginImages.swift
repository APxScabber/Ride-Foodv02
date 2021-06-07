//
//  LoginImages.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.06.2021.
//

import Foundation
import UIKit

enum LoginImages {
    case mainBackground
    case checkBoxEnable
    case checkBoxDisable
}

extension LoginImages {
    var value: UIImage {
        get {
            switch self {
            case .mainBackground:
                return #imageLiteral(resourceName: "bigMan3x")
            case .checkBoxEnable:
                return #imageLiteral(resourceName: "checkBtnOn")
            case .checkBoxDisable:
                return #imageLiteral(resourceName: "checkBtnOff")
            }
        }
    }
}
