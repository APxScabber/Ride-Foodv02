//
//  VBMapButton.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 27.07.2021.
//

import UIKit

class VBMapButton: UIButton {
    
    let leftSideAttachmentView = UIView()
    let bottomView = UIView()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        leftSideAttachmentView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let fullString = NSMutableAttributedString(string: Localizable.Addresses.map.localized)
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "MapArrow")
        let imageString = NSAttributedString(attachment: imageAttachment)
        fullString.append(imageString)
        setAttributedTitle(fullString, for: .normal)
       
        leftSideAttachmentView.backgroundColor = UIColor.ProfileButtonBorderColor
        bottomView.backgroundColor = UIColor.ProfileButtonBorderColor
        
        
        self.contentHorizontalAlignment = .right
        
        addSubview(leftSideAttachmentView)
        addSubview(bottomView)
        
        let padding: CGFloat = 1
        
        NSLayoutConstraint.activate([
            leftSideAttachmentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            leftSideAttachmentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3),
            leftSideAttachmentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 3),
            leftSideAttachmentView.widthAnchor.constraint(equalToConstant: 1),
            
            bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 2),
            bottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 1)
            
        
        ])
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
