//
//  LabelExtension.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 13.06.2021.
//

import UIKit

extension UILabel {
    
    //Закругляем края
    func style() {
        self.layer.cornerRadius = 4
    }
    
    func tariffsInfoStyle(text: String) {
        
        self.textColor = TariffsColors.grayLabelColor.value
        self.font = UIFont(name: MainTextFont.main.rawValue, size: TariffsFontSize.small.rawValue)
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.26
        self.attributedText = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
}
