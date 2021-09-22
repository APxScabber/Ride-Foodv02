//
//  DriverSearchVC.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 19.09.2021.
//


enum ScreenState{
    case search, found
}

protocol DriverSearchDelegate: AnyObject{
    func cancel()
    func changeFrame()
}

import UIKit

class DriverSearchVC: UIViewController {
    
    var requestCount = 0
    
    let cancelButton = VBButton(backgroundColor: .clear, title: "Отмена", cornerRadius: 15, textColor: .black, font: UIFont.SFUIDisplayRegular(size: 17)!, borderWidth: 0, borderColor: UIColor.clear.cgColor)
    let searchWavesView = LoadingWavesCustomView()
    let searchingStatusLabel = UILabel()
    
    let foundDriverView = FoundDriverView.initFromNib()
    
    var toAddress = String()
    var fromAddress = String()
    var tariff = Int()
    var credits = Int()
    var promocodes = [String]()
    var paymentMethod = String()
    var paymentCard = Int()
    
    weak var delegate: DriverSearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addviews(with: .search)
        sendRequest()
        
    }
    
    @objc func cancel(){
        delegate?.cancel()
    }
    
    func sendRequest(){
      
        guard let id = AddressesNetworkManager.shared.getUserID() else {
            print("Invalid ID")
            return
        }
        TaxiNetworkingManager.shared.searchForDrivers(id: id, tariff: tariff, from: fromAddress, to: toAddress, paymentCard: paymentCard, paymentMethod: paymentMethod, promoCodes: promocodes, credit: credits) { [weak self] result in
            guard let self = self else { return }
            switch result{
            case .failure(let error):
                print(error)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.requestCount += 1
                    if self.requestCount == 10{
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 1) {
                                self.removeViews(with: .search)
                                self.delegate?.changeFrame()
                                self.addviews(with: .found)
                            }
                        }
                       
                        return
                    } else if self.requestCount == 5 {
                        self.searchingStatusLabel.text = "Подождите еще немного"
                        self.sendRequest()
                    } else {
                        self.sendRequest()
                    }
                   
                }
            case .success(let data):
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 1) {
                        self.removeViews(with: .search)
                        self.delegate?.changeFrame()
                        self.addviews(with: .found)
                    }
                }
            }
        }
    }
    
    func removeViews(with state: ScreenState){
        switch state{
        case .search:
            searchWavesView.removeFromSuperview()
            searchingStatusLabel.removeFromSuperview()
        case .found:
            foundDriverView.removeFromSuperview()
        }
    }
    
    func addviews(with state: ScreenState){
        switch state {
        case .search:
            configureWavesView()
            configureStatusLabel()
        case .found:
            configureFoundView()
        }
    }
    
    func configureFoundView(){
        view.addSubview(foundDriverView)
        foundDriverView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            foundDriverView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            foundDriverView.topAnchor.constraint(equalTo: view.topAnchor),
            foundDriverView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -5),
            foundDriverView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    func configure(){
        view.backgroundColor = .white
        self.view.layer.cornerRadius = 15
        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        configureCancelButton()
       
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
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35),
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 100),
            cancelButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
    }

}
