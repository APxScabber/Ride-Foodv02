//
//  ProductsCollectionViewCell.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 18.08.2021.
//

import UIKit

class ProductsCollectionViewCell: UICollectionViewCell {
    static let identifier = "ProductsCollectionCell"
    
    let padding: CGFloat = 8
    
    let cellBackgroundView = UIView(frame: .zero)
    
    let productImageView = UIImageView(frame: .zero)
    
    let nameLabel = UILabel(frame: .zero)
    
    let priceLabel = UILabel(frame: .zero)
    
    let weightLabel = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBackgroundView(){
        cellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
      
        
     
        self.addSubview(cellBackgroundView)
        
        self.cellBackgroundView.layer.cornerRadius = 15
        self.cellBackgroundView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        self.cellBackgroundView.layer.shadowOpacity = 0.4
        self.cellBackgroundView.layer.shadowOffset = .zero
        self.cellBackgroundView.layer.shadowRadius = 9
     
        NSLayoutConstraint.activate([
            cellBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            cellBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
            cellBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            cellBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
        ])
    }
    
    func setImageView(){
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        cellBackgroundView.addSubview(productImageView)
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: cellBackgroundView.topAnchor, constant: padding),
            productImageView.centerXAnchor.constraint(equalTo: cellBackgroundView.centerXAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 120),
            productImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    func setNameLabel(){
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        cellBackgroundView.addSubview(nameLabel)
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.SFUIDisplayRegular(size: 13)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor, constant: -15),
            nameLabel.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func setPriceLabel(){
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        cellBackgroundView.addSubview(priceLabel)
        priceLabel.font = UIFont.SFUIDisplayBold(size: 13)
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor, constant: 15),
            priceLabel.bottomAnchor.constraint(equalTo: cellBackgroundView.bottomAnchor, constant: -12),
            priceLabel.widthAnchor.constraint(equalToConstant: 70),
            priceLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func setWeightLabel(){
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        cellBackgroundView.addSubview(weightLabel)
        weightLabel.textAlignment = .right
        weightLabel.font = UIFont.SFUIDisplayRegular(size: 13)
        weightLabel.textColor = UIColor.DarkGrayTextColor
        NSLayoutConstraint.activate([
            weightLabel.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor, constant: -15),
            weightLabel.bottomAnchor.constraint(equalTo: cellBackgroundView.bottomAnchor, constant: -12),
            weightLabel.widthAnchor.constraint(equalToConstant: 70),
            weightLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func setData(product: Product){
        nameLabel.text = product.name
        priceLabel.text = "\(product.price ?? 0) руб"
        weightLabel.text = "\(product.weight ?? 0) г"
        DispatchQueue.global(qos: .userInitiated).async {
            if let imageData = product.icon{
                let url = URL(string: imageData)
                let data = try? Data(contentsOf: url!)
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    self.productImageView.image = image
                }
            }
        }
       
     
        
    }
    
    func configure(){
        setBackgroundView()
        setImageView()
        setNameLabel()
        setPriceLabel()
        setWeightLabel()
        
    }
    
}
