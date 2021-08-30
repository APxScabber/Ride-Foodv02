//
//  CartProductsQTYView.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 29.08.2021.
//

import UIKit

class CartProductsQTYView: UIView {
    
    override public func layoutSubviews() {
           super.layoutSubviews()
        drawOval()
         
       }

    let qtyLabel = UILabel()
    
    let backgroundView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        self.translatesAutoresizingMaskIntoConstraints = false
        drawOval()
        addLabel()
    }
    
     func drawOval() {
        self.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints    = false
        backgroundView.layer.cornerRadius                           = backgroundView.layer.bounds.width / 2
        backgroundView.clipsToBounds                                = false
        backgroundView.backgroundColor                              = UIColor.SeparatorColor
        
        NSLayoutConstraint.activate([
            backgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            backgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 25),
            backgroundView.widthAnchor.constraint(equalToConstant: 25)
        ])
        
        }
    
    func addLabel(){
        qtyLabel.translatesAutoresizingMaskIntoConstraints      = false
        qtyLabel.font                                           = UIFont.SFUIDisplayRegular(size: 10)
        qtyLabel.textColor                                      = UIColor.DarkGrayTextColor
        qtyLabel.textAlignment                                  = .center
        backgroundView.addSubview(qtyLabel)
        qtyLabel.text = "1x"
        NSLayoutConstraint.activate([
            qtyLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            qtyLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            qtyLabel.heightAnchor.constraint(equalToConstant: 20),
            qtyLabel.widthAnchor.constraint(equalToConstant: 18)
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
