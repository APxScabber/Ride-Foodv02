
//  ProfileMenuBackgroundView.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 22.07.2021.
//

import UIKit

class ProfileMenuBackgroundView: UIView {
    let backgroundImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   private func configure(){
    if #available(iOS 13.0, *) {
        backgroundColor = .ProfileBackgroundColor
    } else {
        // Fallback on earlier versions
    }
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    backgroundImageView.image = UIImage(named: "UserProfileBackground")
        addSubview(backgroundImageView)
 
    
    NSLayoutConstraint.activate([
        backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        backgroundImageView.widthAnchor.constraint(equalToConstant: 221),
        backgroundImageView.heightAnchor.constraint(equalToConstant: 421)
    ])
    }
  
}
