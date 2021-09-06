//
//  PromocodeAndCreditsView.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 30.08.2021.
//

import UIKit

enum ViewState {
    case normal, activated
}
class PromocodeAndCreditsView: UIView {
    
    var viewState: ViewState?
    
    override public func layoutSubviews() {
           super.layoutSubviews()
        configureBackgroundView()
         
       }
    
    
    
    var iconImage = UIImage()
    
    var title: String = ""
    
    var discount: String = ""
    
    let backgroundView = UIView()
    
    let imageView = UIImageView()
    
    let label = UILabel()
    
    let discountLabel = UILabel()
    
    init(image: UIImage, title: String, state: ViewState) {
        super.init(frame: .zero)
        self.iconImage = image
        self.title = title
        self.viewState = state
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
        switch viewState {
        case .normal:
            configureImageView()
        case .activated:
            configureDiscountLabel()
        case .none:
            break
        }
        
        configureLabel()
        set(title: title, image: iconImage, discount: discount)
    }
    
    func configureBackgroundView(){
       
        self.addSubview(backgroundView)
        
        switch viewState {
        case .normal:
            backgroundView.backgroundColor = .white
        case .activated:
            backgroundView.backgroundColor = UIColor.SeparatorColor
        default:
            break
        }
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
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
            backgroundView.widthAnchor.constraint(equalToConstant: 170)
        ])
    }
    
    func configureDiscountLabel(){
        backgroundView.addSubview(discountLabel)
        discountLabel.textColor = UIColor.SkillBoxGreenColor
        discountLabel.font      = UIFont.SFUIDisplayBold(size: 15)
        discountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            discountLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            discountLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 15),
            discountLabel.heightAnchor.constraint(equalToConstant: 16),
            discountLabel.widthAnchor.constraint(equalToConstant: 20)
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
        switch viewState {
        case .normal:
            label.textColor = .black
        default:
            label.textColor = .DarkGrayTextColor
        }
        
        switch viewState {
        case .normal:
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
                label.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
                label.heightAnchor.constraint(equalToConstant: 19)
            ])
        case .activated:
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: discountLabel.trailingAnchor, constant: 8),
                label.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
                label.heightAnchor.constraint(equalToConstant: 19)
            ])
        
        case .none:
            break
        }
      
    }
    
    func set(title: String, image: UIImage?, discount: String?){
        self.label.text = title
        switch viewState {
        case .normal:
            self.imageView.image = image
        case .activated:
            self.discountLabel.text = "-\(discount)"
        case .none:
        break
    }

}
}
