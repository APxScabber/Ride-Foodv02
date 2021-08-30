//
//  CartTableViewCell.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 29.08.2021.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    static let reuseID = "cartIdentifier"
    
    let nameLabel = UILabel()
    
    let priceLabel = UILabel()
    
    let qtyView = CartProductsQTYView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    
    private func configure(){
        
        configureQTYView()
        configureNameLabel()
        configurePriceLabel()
        
    }
    
    func configureQTYView(){
        self.addSubview(qtyView)
        
        NSLayoutConstraint.activate([
            qtyView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            qtyView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            qtyView.heightAnchor.constraint(equalToConstant: 25),
            qtyView.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    func configureNameLabel(){
        self.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints         = false
        nameLabel.font                                              = UIFont.SFUIDisplayRegular(size: 14)
        nameLabel.textColor                                         = .black
        nameLabel.numberOfLines                                     = 0
        nameLabel.lineBreakMode                                     = .byWordWrapping
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            nameLabel.leadingAnchor.constraint(equalTo: qtyView.trailingAnchor, constant: 15),
            nameLabel.widthAnchor.constraint(equalToConstant: 180),
            nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6)
            
        ])

    }
    
    func configurePriceLabel(){
        self.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints            = false
        priceLabel.font                                                 = UIFont.SFUIDisplayRegular(size: 15)
        priceLabel.textColor                                            = UIColor.DarkGrayTextColor
        priceLabel.textAlignment                                        = .right
        
        NSLayoutConstraint.activate([
            priceLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            priceLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func set(with product: FoodOrderMO){
        nameLabel.text = product.name
        priceLabel.text = "\(product.price * product.qty) руб"
        qtyView.qtyLabel.text = "\(product.qty)х"
    }

}
