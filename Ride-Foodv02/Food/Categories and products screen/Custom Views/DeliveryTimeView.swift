//
//  DeliveryTimeView.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 30.08.2021.
//

import UIKit

class DeliveryTimeView: UIView {
    
    let mainlabel = UILabel()
    
    let priceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.SeparatorColor
        configureMainLabel()
        configurePriceLabel()
        
    }
    
    func configureMainLabel(){
        self.addSubview(mainlabel)
        mainlabel.translatesAutoresizingMaskIntoConstraints      = false
        mainlabel.font                                           = UIFont.SFUIDisplayRegular(size: 17)
        mainlabel.textColor                                      = UIColor.black
        
        NSLayoutConstraint.activate([
            mainlabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mainlabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            mainlabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configurePriceLabel(){
        self.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints        = false
        priceLabel.font                                             = UIFont.SFUIDisplayRegular(size: 15)
        priceLabel.textColor                                        = UIColor.DarkGrayTextColor
        priceLabel.textAlignment                                    = .right
        
        NSLayoutConstraint.activate([
            priceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            priceLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            priceLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        
    }
    
     func set(with deliveryTime: Int, deliveryPrice: Int){
        mainlabel.attributedText = UIHelper.createTitleAttributedString(titleString: Localizable.Delivery.deliveryTime.localized, font: UIFont.SFUIDisplayRegular(size: 17)!, color: .black, bodyString: " ≈\(deliveryTime) \(Localizable.Delivery.deliveryMin.localized)", bodyColor: UIColor.saleOrangeColor)
        priceLabel.text = "\(deliveryPrice) \(Localizable.Delivery.deliveryMoney.localized)"
    }

}
