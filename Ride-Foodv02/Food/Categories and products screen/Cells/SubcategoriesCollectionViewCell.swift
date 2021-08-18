//
//  SubcategoriesCollectionViewCell.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 18.08.2021.
//

import UIKit

class SubcategoriesCollectionViewCell: UICollectionViewCell {
    static let identifier = "SubcategoriesCollectionCell"
    
    let padding: CGFloat = 8
    
    let titleBackgroundView = UIView(frame: .zero)
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        self.backgroundColor = .white
        configureBackgoundView()
        configureTitleLabel()
    }
    
    func configureBackgoundView(){
        addSubview(titleBackgroundView)
        titleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        titleBackgroundView.layer.cornerRadius = 15
        titleBackgroundView.backgroundColor = UIColor.SeparatorColor
        
        NSLayoutConstraint.activate([
            titleBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
            titleBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2),
            titleBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            titleBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2)
        ])
       
    }
    func configureTitleLabel(){
        titleBackgroundView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.SFUIDisplayRegular(size: 15)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.DarkGrayTextColor
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.titleBackgroundView.topAnchor, constant: 6),
            titleLabel.bottomAnchor.constraint(equalTo: self.titleBackgroundView.bottomAnchor, constant: -6),
            titleLabel.leadingAnchor.constraint(equalTo: titleBackgroundView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: titleBackgroundView.trailingAnchor, constant: -15)
            
        ])
        
    }
    
}
