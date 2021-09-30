//
//  EmptyCartView.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 03.09.2021.
//

import UIKit

class EmptyCartView: UIView {
    
    let imageView   = UIImageView()
    let bodyLabel   = UILabel()
    let button      = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        self.translatesAutoresizingMaskIntoConstraints = false
        configureImageView()
        configureBodylabel()
        configureButton()
        
    }
    
    func configureImageView(){
        self.addSubview(imageView)
        let imagePadding: CGFloat = 30
        imageView.image                                     = UIImage(named: "EmptyCartImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: imagePadding),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureBodylabel(){
        self.addSubview(bodyLabel)
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.font                                      = UIFont.SFUIDisplayRegular(size: 20)
        bodyLabel.textColor                                 = UIColor.DarkGrayTextColor
        bodyLabel.text                                      = Localizable.Food.cartIsEmpty.localized
        
        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            bodyLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bodyLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        
    }
    
    func configureButton(){
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints    = false
        button.backgroundColor                              = UIColor.SkillboxIndigoColor
        button.layer.cornerRadius                           = 15
        button.setTitle(Localizable.Food.comebackToShopping.localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
}
