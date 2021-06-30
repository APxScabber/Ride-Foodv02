//
//  ButtonExtension.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.06.2021.
//

import UIKit

extension UIButton {
    
    //Закругляем края у кнопки
    func style() {
        self.layer.cornerRadius = 15
    }
    
    func tariffsSmallStyle() {
        self.layer.cornerRadius = self.frame.height / 3.5
    }
}
