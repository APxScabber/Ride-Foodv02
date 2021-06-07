//
//  ButtonExtension.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.06.2021.
//

import UIKit


extension UIButton {
    
    func style() {
        self.backgroundColor = #colorLiteral(red: 0.3084548712, green: 0.352679342, blue: 1, alpha: 1)
        self.layer.cornerRadius = self.frame.height / 4
    }
}
