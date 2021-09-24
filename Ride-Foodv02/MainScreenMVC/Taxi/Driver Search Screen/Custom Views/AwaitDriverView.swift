//
//  AwaitDriverView.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 23.09.2021.
//

import UIKit

class AwaitDriverView: UIView {
    
    var carName         = String()
    var carNumber       = String()
    var carRegion       = String()
    var driverStatus    = String()
    var time            = String()
    
    
   
    
    let statusLabel             = UILabel()
    let waitingDescriptionLabel = UILabel()
    
    let timeLabel               = UILabel()
    
    let carNameLabel            = UILabel()
    
    let callView                = AwaitActionView(image: UIImage(named: "CallImage")!, name: "Позвонить")
    let onMyWayView             = AwaitActionView(image: UIImage(named: "WaitImage")!, name: "Скоро буду")
    
    let carNumberView           = CarNumberView.initFromNib()
    
    @IBOutlet weak var roundedSwipeView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    
    func setData(name: String, number: String, region: String){
        self.carName = name
        self.carNumber = number
        self.carRegion = region
    }
    
    func configure(state: DriverStatus){
        self.containerView.layer.cornerRadius = 15
        self.containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        configureNameAndNumberViews()
        switch state {
        case .onTheWay:
            configureNameLabel(with: state)
            configureTimeLabel(with: state)
            configureActions(with: state)
        case .arrived:
            configureNameLabel(with: state)
            configureActions(with: state)
        case .isWaiting:
            configureNameLabel(with: state)
            configureTimeLabel(with: state)
            configureActions(with: state)
        case .almostThere:
            configureNameLabel(with: state)
            configureActions(with: state)
        }
    }
    
    func configureNameLabel(with state: DriverStatus){
        containerView.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.text = driverStatus
        statusLabel.font = UIFont.SFUIDisplayRegular(size: 28)
        
        switch state {
        case .onTheWay:
            statusLabel.text = MainScreenConstants.DriverStatusText.OnTheWay.rawValue
            statusLabel.textColor = UIColor.black
            statusLabel.textAlignment = .right
            NSLayoutConstraint.activate([
                statusLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
                statusLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 65),
                statusLabel.heightAnchor.constraint(equalToConstant: 35),
                statusLabel.widthAnchor.constraint(equalToConstant: 170)
            ])
        case .almostThere:
            statusLabel.text = MainScreenConstants.DriverStatusText.AlmostThere.rawValue
            statusLabel.textColor = UIColor.black
            statusLabel.textAlignment = .center
            NSLayoutConstraint.activate([
                statusLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
                statusLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                statusLabel.heightAnchor.constraint(equalToConstant: 35),
                statusLabel.widthAnchor.constraint(equalToConstant: 200)
            ])
        case .arrived:
            statusLabel.text = MainScreenConstants.DriverStatusText.WaitingForYou.rawValue
            statusLabel.textColor = UIColor.saleOrangeColor
            statusLabel.textAlignment = .center
            NSLayoutConstraint.activate([
                statusLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
                statusLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                statusLabel.heightAnchor.constraint(equalToConstant: 35),
                statusLabel.widthAnchor.constraint(equalToConstant: 200)
            ])
        case .isWaiting:
            statusLabel.text = MainScreenConstants.DriverStatusText.Waiting.rawValue
            statusLabel.textColor = UIColor.black
            statusLabel.textAlignment = .right
            NSLayoutConstraint.activate([
                statusLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
                statusLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 65),
                statusLabel.heightAnchor.constraint(equalToConstant: 35),
                statusLabel.widthAnchor.constraint(equalToConstant: 170)
            ])
        }
        
    }
    
    func configureTimeLabel(with state: DriverStatus){
        timeLabel.font = UIFont.SFUIDisplayRegular(size: 28)
        switch state {
        case .onTheWay:
            containerView.addSubview(timeLabel)
            timeLabel.text = time
            timeLabel.textColor = UIColor.saleOrangeColor
            timeLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                timeLabel.topAnchor.constraint(equalTo: statusLabel.topAnchor),
                timeLabel.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor, constant: 10),
                timeLabel.heightAnchor.constraint(equalToConstant: 35),
                timeLabel.widthAnchor.constraint(equalToConstant: 100)
            ])
        case .almostThere:
            return
        case .arrived:
            return
        case .isWaiting:
            self.addSubview(timeLabel)
            timeLabel.text = time
            timeLabel.textColor = UIColor.red
            timeLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                timeLabel.topAnchor.constraint(equalTo: statusLabel.topAnchor),
                timeLabel.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor, constant: 10),
                timeLabel.heightAnchor.constraint(equalToConstant: 35),
                timeLabel.widthAnchor.constraint(equalToConstant: 100)
            ])
        }
        
    }
    
    func configureNameAndNumberViews(){
        containerView.addSubview(carNameLabel)
        carNameLabel.text = carName
        carNameLabel.font = UIFont.SFUIDisplayRegular(size: 19)
        carNameLabel.textAlignment = .center
        containerView.addSubview(carNumberView)
        carNumberView.carNumberLabel.text = "\(carNumber)"
        carNumberView.carRegionNumber.text = "\(carRegion)"
        carNumberView.backgroundColor = UIColor.SeparatorColor
        
        carNameLabel.translatesAutoresizingMaskIntoConstraints = false
        carNumberView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            carNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 55),
            carNameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            carNameLabel.heightAnchor.constraint(equalToConstant: 40),
            carNameLabel.widthAnchor.constraint(equalToConstant: 200),
            
            carNumberView.topAnchor.constraint(equalTo: carNameLabel.bottomAnchor, constant: 5),
            carNumberView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            carNumberView.heightAnchor.constraint(equalToConstant: 25),
            carNumberView.widthAnchor.constraint(equalToConstant: 95)
            
        ])
    }
    
    func configureActions(with state: DriverStatus){
        switch state {
        case .onTheWay:
            containerView.addSubview(callView)
            callView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                callView.topAnchor.constraint(equalTo: carNumberView.bottomAnchor, constant: 20),
                callView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                callView.heightAnchor.constraint(equalToConstant: 72),
                callView.widthAnchor.constraint(equalToConstant: 82)
            ])
        case .almostThere:
            self.addSubview(callView)
            callView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                callView.topAnchor.constraint(equalTo: carNumberView.bottomAnchor, constant: 20),
                callView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                callView.heightAnchor.constraint(equalToConstant: 72),
                callView.widthAnchor.constraint(equalToConstant: 82)
            ])
        case .arrived:
            containerView.addSubview(callView)
            containerView.addSubview(onMyWayView)
            callView.translatesAutoresizingMaskIntoConstraints = false
            onMyWayView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                callView.topAnchor.constraint(equalTo: carNumberView.bottomAnchor, constant: 20),
                callView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 90),
                callView.heightAnchor.constraint(equalToConstant: 72),
                callView.widthAnchor.constraint(equalToConstant: 82),
                
                onMyWayView.topAnchor.constraint(equalTo: carNumberView.bottomAnchor, constant: 20),
                onMyWayView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -90),
                onMyWayView.heightAnchor.constraint(equalToConstant: 72),
                onMyWayView.widthAnchor.constraint(equalToConstant: 82),
            ])
        case .isWaiting:
            containerView.addSubview(callView)
            callView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                callView.topAnchor.constraint(equalTo: carNumberView.bottomAnchor, constant: 20),
                callView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                callView.heightAnchor.constraint(equalToConstant: 72),
                callView.widthAnchor.constraint(equalToConstant: 82)
            ])
        }
    }
    

}
