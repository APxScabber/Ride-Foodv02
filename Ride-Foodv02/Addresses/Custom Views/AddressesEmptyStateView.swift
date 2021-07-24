//
//  AddressesEmptyStateView.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 21.07.2021.
//

import UIKit

class AddressesEmptyStateView: UIView {
    
    let messageLabel = UILabel()
    let emptyImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        backgroundColor = UIColor.ProfileBackgroundColor
        messageLabel.text = "Здесь пока пусто..."
        messageLabel.font = UIFont.SFUIDisplayRegular(size: 26)
        messageLabel.textColor = UIColor.DarkGrayTextColor
        emptyImageView.image = UIImage(named: "emptyHouseImage")
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)
        addSubview(emptyImageView)
        
        NSLayoutConstraint.activate([
            emptyImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 125),
            emptyImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            emptyImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            emptyImageView.heightAnchor.constraint(equalToConstant: 230),
            
            messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 20),
            messageLabel.heightAnchor.constraint(equalToConstant: 30)
            
        
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
