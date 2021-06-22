//
//  TextViewExtension.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 18.06.2021.
//

import UIKit

extension UITextView {
    
    func tariffsInfoStyle(text: String) {
        
        self.textColor = TariffsColors.grayLabelColor.value
        self.font = UIFont(name: MainTextFont.main.rawValue, size: TariffsFontSize.small.rawValue)
        self.text = text
        //self.numberOfLines = 0
        //self.lineBreakMode = .byWordWrapping
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineHeightMultiple = 1.26
//        self.attributedText = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
}
