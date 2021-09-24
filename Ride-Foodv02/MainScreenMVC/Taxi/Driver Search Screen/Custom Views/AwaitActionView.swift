//
//  AwaitActionView.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 23.09.2021.
//

import UIKit

class AwaitActionView: UIView {
    
    var image = UIImage()
    var name = String()
    
    var circleView = UIView()
    var iconImageView = UIImageView()
    var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(image: UIImage, name: String) {
        super.init(frame: .zero)
        self.image = image
        self.name = name
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        self.backgroundColor = .white
        configureCircleView()
        configureImageView()
        configureNameLabel()
    }
    
    func configureCircleView(){
       
        addSubview(circleView)
        circleView.backgroundColor = .white
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.layer.cornerRadius = 30
       
        circleView.addShadowToView(shadow_color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.1),
                                           offset: CGSize(width: 0, height: 0),
                                           shadow_radius: 10,
                                           shadow_opacity: 1,
                                           corner_radius: 30)
        
        NSLayoutConstraint.activate([
            circleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            circleView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            circleView.heightAnchor.constraint(equalToConstant: 60),
            circleView.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configureImageView(){
        circleView.addSubview(iconImageView)
        iconImageView.image = image
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 23),
            iconImageView.widthAnchor.constraint(equalToConstant: 23)
        ])
    }
    
    func configureNameLabel(){
        addSubview(titleLabel)
        titleLabel.text = name
        titleLabel.font = UIFont.SFUIDisplayRegular(size: 12)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: circleView.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 15),
            titleLabel.widthAnchor.constraint(equalToConstant: 80)
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
