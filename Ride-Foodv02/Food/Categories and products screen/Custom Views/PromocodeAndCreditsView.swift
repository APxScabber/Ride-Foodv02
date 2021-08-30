//
//  PromocodeAndCreditsView.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 30.08.2021.
//

import UIKit

class PromocodeAndCreditsView: UIView {
    
    override public func layoutSubviews() {
           super.layoutSubviews()
        configureBackgroundView()
         
       }
    
    var iconImage = UIImage()
    
    var title: String = ""
    
    let backgroundView = UIView()
    
    let imageView = UIImageView()
    
    let label = UILabel()
    
    init(image: UIImage, title: String) {
        super.init(frame: .zero)
        self.iconImage = image
        self.title = title
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
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        configureBackgroundView()
        configureImageView()
        configureLabel()
        set(title: title, image: iconImage)
    }
    
    func configureBackgroundView(){
       
        self.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 15
        backgroundView.layer.shadowPath = UIBezierPath(rect: backgroundView.bounds).cgPath
        backgroundView.layer.shadowRadius = 5
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundView.layer.shadowOpacity = 1
        backgroundView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        
        NSLayoutConstraint.activate([
            backgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            backgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 50),
            backgroundView.widthAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    func configureImageView(){
        backgroundView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 15),
            imageView.heightAnchor.constraint(equalToConstant: 16),
            imageView.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configureLabel(){
        backgroundView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.SFUIDisplayRegular(size: 15)
        label.textColor = .black
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            label.heightAnchor.constraint(equalToConstant: 19)
        ])
    }
    
    func set(title: String, image: UIImage){
        self.label.text = title
        self.imageView.image = image
    }

}
