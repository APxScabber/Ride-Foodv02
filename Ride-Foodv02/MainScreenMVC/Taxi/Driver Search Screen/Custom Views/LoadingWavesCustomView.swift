//
//  LoadingWavesCustomView.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 20.09.2021.
//

import UIKit

class LoadingWavesCustomView: UIView {
    
    let imageOne    = UIImageView(image: UIImage(named: "SearchOne"))
    let imageTwo    = UIImageView(image: UIImage(named: "SearchTwo"))
    let imageThree  = UIImageView(image: UIImage(named: "SearchThree"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        self.translatesAutoresizingMaskIntoConstraints = false
        configureFirstImage()
        configureSecondImage()
        configureThirdImage()
        setConstraints()
        animateImages()
    }
    
    func animateImages(){
        UIView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.imageTwo.alpha = 1
            self.imageThree.alpha = 1
            self.imageThree.alpha = 0
            self.imageTwo.alpha = 0

        }, completion: nil)
    }
    
    func setConstraints(){
        for i in [imageOne, imageTwo, imageThree]{
            NSLayoutConstraint.activate([
                i.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                i.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        }
    }
    
    func configureFirstImage(){
        imageOne.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageOne)
        imageOne.alpha = 1
    }
    
    func configureSecondImage(){
        imageTwo.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageTwo)
        imageTwo.alpha = 0
    }
    
    func configureThirdImage(){
        imageThree.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageThree)
        imageThree.alpha = 0
    }
    
}
