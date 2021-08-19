//
//  TaxiSpecifyFromTo.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 19.08.2021.
//

import Foundation
import UIKit

enum TaxiSpecifyFromToColor {
    case white
}

extension TaxiSpecifyFromToColor {
    var value: UIColor {
        get {
            switch self {
            case .white:
                return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            }
        }
    }
}
