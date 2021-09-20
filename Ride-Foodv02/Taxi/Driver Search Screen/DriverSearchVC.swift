//
//  DriverSearchVC.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 19.09.2021.
//


enum ScreenState{
    case search, found
}

protocol CancelButtonProtocol: AnyObject{
    func cancel()
}

import UIKit

class DriverSearchVC: UIViewController {
    
    let cancelButton = VBButton(backgroundColor: .clear, title: "Отмена", cornerRadius: 15, textColor: .black, font: UIFont.SFUIDisplayRegular(size: 17)!, borderWidth: 0, borderColor: UIColor.clear.cgColor)
    let searchWavesView = LoadingWavesCustomView()
    let searchingStatusLabel = UILabel()
    
    var toAddress = String()
    var fromAddress = String()
    var tariff = Int()
    var credits = Int()
    var promocodes = [String]()
    var paymentMethod = String()
    var paymentCard = Int()
    
    weak var delegate: CancelButtonProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    @objc func cancel(){
        delegate?.cancel()
    }
    
    
    
    func configure(){
        view.backgroundColor = .white
        self.view.layer.cornerRadius = 15
        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        configureCancelButton()
        configureWavesView()
        configureStatusLabel()
    }
    
    func setLabelText(text: String){
        searchingStatusLabel.text = text
    }
    
    func configureStatusLabel(){
        view.addSubview(searchingStatusLabel)
        searchingStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        searchingStatusLabel.textColor          = UIColor.saleOrangeColor
        searchingStatusLabel.font               = UIFont.SFUIDisplaySemibold(size: 17)
        setLabelText(text: "Ищем подходящий вариант")
        NSLayoutConstraint.activate([
            searchingStatusLabel.leadingAnchor.constraint(equalTo: searchWavesView.trailingAnchor, constant: 10),
            searchingStatusLabel.centerYAnchor.constraint(equalTo: searchWavesView.centerYAnchor),
            searchingStatusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            searchingStatusLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    func configureWavesView(){
        view.addSubview(searchWavesView)
        
        NSLayoutConstraint.activate([
            searchWavesView.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
            searchWavesView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            searchWavesView.heightAnchor.constraint(equalToConstant: 30),
            searchWavesView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    func configureCancelButton(){
        view.addSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 100),
            cancelButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }

}
