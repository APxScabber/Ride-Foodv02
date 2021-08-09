//
//  VBConfirmAlertVC.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 31.07.2021.
//

import UIKit


protocol DeleteAddressProtocol {
   func deleteAddress()
   
}

class VBConfirmAlertVC: UIViewController {
    
    var delegate: DeleteAddressProtocol?
    
    var alertTitle: String?
    var confirmOptionTitle: String?
    var cancelOptionTitle: String?
    
    
    let containerView       = UIView()
    let attributeView       = UIView()
    let titleLabel          = UILabel()
    let confirmOptionButton = VBButton(backgroundColor: UIColor.SkillboxIndigoColor, title: "" , cornerRadius: 15, textColor: .white, font: UIFont.SFUIDisplayRegular(size: 17)!, borderWidth: 0, borderColor: UIColor.white.cgColor )
    let cancelOptionButton  = VBButton(backgroundColor: .clear, title: "", cornerRadius: 0, textColor: .black, font: UIFont.SFUIDisplayRegular(size: 17)!, borderWidth: 0, borderColor: UIColor.white.cgColor)
    
    let horizontalPadding: CGFloat = 25
    
    
   
    
    @objc init(alertTitle: String, alertColor: UIColor , confirmTitle: String, cancelTitle: String) {
        self.titleLabel.textColor   = alertColor
        self.alertTitle             = alertTitle
        self.confirmOptionTitle     = confirmTitle
        self.cancelOptionTitle      = cancelTitle
        
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        view.insetsLayoutMarginsFromSafeArea = false
        setContainerView()
        setTitleLabel()
        setConfigureButton()
        setCancelButton()
       
        setAttributeView()
//        setBottomView()
        // Do any additional setup after loading the view.
    }
    
    func setAttributeView(){
        attributeView.translatesAutoresizingMaskIntoConstraints = false
        attributeView.backgroundColor                           = UIColor.attributeViewColor
        
        view.addSubview(attributeView)
        NSLayoutConstraint.activate([
            attributeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            attributeView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -10),
            attributeView.widthAnchor.constraint(equalToConstant: 40),
            attributeView.heightAnchor.constraint(equalToConstant: 5)
        ])
    }
    
    func setContainerView(){
        containerView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            containerView.backgroundColor   = .systemBackground
        } else {
            // Fallback on earlier versions
        }
        containerView.layer.cornerRadius    = 15
        containerView.layer.maskedCorners   = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
    }
    
    func setTitleLabel(){
        titleLabel.text = alertTitle
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.SFUIDisplayRegular(size: 17)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -horizontalPadding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: horizontalPadding)
            
        ])
    }
    
    @objc func confirmAction(){
        print("gonna delete")
        self.dismiss(animated: true, completion: nil)
        delegate?.deleteAddress()
        
    }
    
    @objc func cancelAction(){
        print("gonna cancel")
        self.dismiss(animated: true)
    }
    
    
    func setConfigureButton(){
        confirmOptionButton.setTitle(confirmOptionTitle, for: .normal)
        confirmOptionButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        containerView.addSubview(confirmOptionButton)
        
        NSLayoutConstraint.activate([
            confirmOptionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: horizontalPadding),
            confirmOptionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -horizontalPadding),
            confirmOptionButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: horizontalPadding),
            confirmOptionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setCancelButton(){
        cancelOptionButton.setTitle(cancelOptionTitle, for: .normal)
        cancelOptionButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        containerView.addSubview(cancelOptionButton)
        
        NSLayoutConstraint.activate([
            cancelOptionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: horizontalPadding),
            cancelOptionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -horizontalPadding),
            cancelOptionButton.heightAnchor.constraint(equalToConstant: 50),
            cancelOptionButton.topAnchor.constraint(equalTo: confirmOptionButton.bottomAnchor, constant: horizontalPadding)
        ])
    }


}
