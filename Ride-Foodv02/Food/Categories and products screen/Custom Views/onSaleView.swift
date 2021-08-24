//
//  onSaleView.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 24.08.2021.
//

import UIKit

class OnSaleView: UIView {
    
    var salePercentage = Int()
    
    let imageView = UIImageView()
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(salePercentage: Int) {
        self.salePercentage = salePercentage
        super.init(frame: .zero)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "OnSaleImage")
        
        imageView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "-\(salePercentage)%"
        label.font = UIFont.SFUIDisplaySemibold(size: 12)
        label.textColor = .white
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 14),
            label.widthAnchor.constraint(equalToConstant: 30)
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
