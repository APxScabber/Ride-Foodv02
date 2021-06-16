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
    
    func tariffsInfoStyle() {
        
        self.textColor = TariffsColors.grayLabelColor.value
        self.font = UIFont(name: MainTextFont.main.rawValue, size: TariffsFontSize.small.rawValue)
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.26
        self.attributedText = NSMutableAttributedString(string: "Ясность нашей позиции очевидна: постоянный количественный рост и сфера нашей активности обеспечивает актуальность системы массового участия. Внезапно, ключевые особенности структуры проекта и по сей день остаются уделом либералов, которые жаждут быть объявлены нарушающими общечеловеческие нормы этики и морали. Кстати,  реплицированные с зарубежных источников, современные исследования формируют глобальную экономическую сеть.", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
}
