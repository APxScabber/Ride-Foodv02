//
//  FoodOrderBottomView.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 26.08.2021.
//

import UIKit

class FoodOrderBottomView: UIView {
    let titleLabel       = UILabel()
    let priceLabel      = UILabel()
    let oldPriceLabel    = UILabel()
    
    var title       = String()
    var price       = Int()
    var oldPrice: Int?
    
    init(title: String, price: Int, oldPrice: Int? ) {
        super.init(frame: .zero)
        self.title = title
        self.price = price
        if oldPrice != nil{
            self.oldPrice = oldPrice
        }
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalPadding: CGFloat = 13
        
        self.backgroundColor    = UIColor.SkillboxIndigoColor
        self.layer.cornerRadius = 15
        
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints    = false
        titleLabel.textColor                                    = .white
        titleLabel.font                                         = UIFont.SFUIDisplayRegular(size: 18)
        titleLabel.text                                         = title
        
        
        self.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints    = false
        priceLabel.textColor                                    = .white
        priceLabel.font                                         = UIFont.SFUIDisplaySemibold(size: 17)
        priceLabel.text                                         = "\(price) руб"
        priceLabel.textAlignment                                = .right
      
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: horizontalPadding),
            titleLabel.heightAnchor.constraint(equalToConstant: 17),
            titleLabel.widthAnchor.constraint(equalToConstant: 160),
            
            priceLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -horizontalPadding),
            priceLabel.heightAnchor.constraint(equalToConstant: 17),
            priceLabel.widthAnchor.constraint(equalToConstant: 100),
        ])
        
        if oldPrice != nil{
        self.addSubview(oldPriceLabel)
            oldPriceLabel.translatesAutoresizingMaskIntoConstraints    = false
            oldPriceLabel.textColor                                    = .white
            oldPriceLabel.font                                         = UIFont.SFUIDisplaySemibold(size: 12)
            oldPriceLabel.attributedText = NSMutableAttributedString(string: "\(oldPrice ?? 0) руб", attributes: [
                            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                            NSAttributedString.Key.font: UIFont.SFUIDisplayRegular(size: 11)!,
                            NSAttributedString.Key.foregroundColor: UIColor.white
                            ])
            
            NSLayoutConstraint.activate([
                oldPriceLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                oldPriceLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -5),
                oldPriceLabel.heightAnchor.constraint(equalToConstant: 17),
                oldPriceLabel.widthAnchor.constraint(equalToConstant: 70)
            ])
        }
        
        
        
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
