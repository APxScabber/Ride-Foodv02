//
//  ProfileMenuBackgroundView.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 22.07.2021.
//

import UIKit

class ProfileMenuBackgroundView: UIView {
    let backgroundImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "UserProfileBackground")
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   private func configure(){
        addSubview(backgroundImageView)
    NSLayoutConstraint.activate([
        backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        backgroundImageView.widthAnchor.constraint(equalToConstant: 221),
        backgroundImageView.heightAnchor.constraint(equalToConstant: 421)
    ])
    }
  
}
