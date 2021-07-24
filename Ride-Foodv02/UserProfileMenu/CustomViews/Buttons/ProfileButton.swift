//
//  ProfileButton.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 24.07.2021.
//

import UIKit

class VBButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(backgroundColor: UIColor, title: String, cornerRadius: CGFloat, textColor: UIColor, font: UIFont, borderWidth: CGFloat, borderColor: CGColor) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = cornerRadius
        self.setTitleColor(textColor, for: .normal)
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        titleLabel?.font = font
        configure()
    }
    
    private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
