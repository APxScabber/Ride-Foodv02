//
//  UIViewControllerExtensions.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 01.08.2021.
//

import UIKit

extension UIViewController{
    func placeIntIntoString(int: Int) -> String{
        guard int != 0 else {
            return ""
        }
        return "\(int)"
    }
}
