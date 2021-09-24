//
//  AwaitDriverView.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 23.09.2021.
//

import UIKit

protocol CloseViewDelegate: AnyObject{
    func close()
}

class AwaitDriverView: UIView {
    
    // storyboard contraints
    
    @IBOutlet weak var swipeViewToTopConstraint: NSLayoutConstraint!
    
    
    var currentStatus: DriverStatus?
    
    var carName         = String()
    var carNumber       = String()
    var carRegion       = String()
    var driverStatus    = String()
    
    let driverToClientDuration = 10
    let driverWaitingDuration = 15
    let paidDriverWaitingDuration = 10
    
    weak var delegate: CloseViewDelegate?
    
//    Timer components
    var timer: Timer?
    var totalDuration = Int()
   
    
    let statusLabel             = UILabel()
    let waitingDescriptionLabel = UILabel()
    
    let timeLabel               = UILabel()
    
    let carNameLabel            = UILabel()
    
    let callView                = AwaitActionView(image: UIImage(named: "CallImage")!, name: "Позвонить")
    let onMyWayView             = AwaitActionView(image: UIImage(named: "WaitImage")!, name: "Скоро буду")
    
    let carNumberView           = CarNumberView.initFromNib()
    
    @IBOutlet weak var roundedSwipeView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    
// Business logic part
    
    func startTimer(with duration: Int){
       totalDuration = duration
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        }
    
    
    @objc func countdown() {
        var minutes: Int
        var seconds: Int
       
        if totalDuration == 0 {
            setBehaviorDuringCountDown(timer: timer ?? Timer())
          
        }
        if totalDuration >= 1{
            totalDuration = totalDuration - 1
        }
        minutes = (totalDuration % 3600) / 60
        seconds = (totalDuration % 3600) % 60
       timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
        
        if totalDuration <= 10 && currentStatus == .isWaiting{
            timeLabel.textColor = UIColor.red
        } else if currentStatus == .paidWaiting{
            timeLabel.textColor = UIColor.red
        } else {
            timeLabel.textColor = UIColor.saleOrangeColor
        }
    }
    
    func setBehaviorDuringCountDown(timer: Timer){
        timer.invalidate()
        switch currentStatus{
        case .onTheWay:
            self.configure(state: .almostThere)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                DispatchQueue.main.async {
                    self.configure(state: .arrived)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 8){
                self.startTimer(with: self.driverWaitingDuration)
                self.configure(state: .isWaiting)
                self.waitingDescriptionLabel.text = MainScreenConstants.DriverStatusText.FreeWaitingDescription.rawValue
            }
        case .almostThere:
            break
        case .arrived:
          break
        case .isWaiting:
            timer.invalidate()
            self.startTimer(with: self.paidDriverWaitingDuration)
            self.configure(state: .paidWaiting)
            self.waitingDescriptionLabel.text = MainScreenConstants.DriverStatusText.PaidWaitingDesctiption.rawValue
        case .none:
            break
        case .paidWaiting:
            timer.invalidate()
            delegate?.close()
            
        }
    }
    
    func setData(name: String, number: String, region: String){
        self.carName = name
        self.carNumber = number
        self.carRegion = region
    }
    
    
    
    
    
//    UI Part
    
    func configure(state: DriverStatus){
        currentStatus = state
        self.containerView.layer.cornerRadius = 15
        self.containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        configureNameAndNumberViews(state: state)
        UIView.animate(withDuration: 0.5) {
           
            switch state {
            case .onTheWay:
                self.configureNameLabel(with: state)
                self.configureTimeLabel(with: state)
                self.configureActions(with: state)
            case .arrived:
                self.configureNameLabel(with: state)
                self.configureTimeLabel(with: state)
                self.configureActions(with: state)
            case .isWaiting:
                self.configureNameLabel(with: state)
                self.configureTimeLabel(with: state)
                self.configureActions(with: state)
            case .almostThere:
                self.configureNameLabel(with: state)
                self.configureTimeLabel(with: state)
                self.configureActions(with: state)
            case .paidWaiting:
                self.configureNameLabel(with: state)
                self.configureTimeLabel(with: state)
                self.configureActions(with: state)
            }
        }
   
    }
    
    func configureNameLabel(with state: DriverStatus){
        containerView.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
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
                statusLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
                statusLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                statusLabel.heightAnchor.constraint(equalToConstant: 35),
                statusLabel.widthAnchor.constraint(equalToConstant: 200)
            ])
        case .arrived:
            statusLabel.text = MainScreenConstants.DriverStatusText.WaitingForYou.rawValue
            statusLabel.textColor = UIColor.saleOrangeColor
            statusLabel.textAlignment = .center
            NSLayoutConstraint.activate([
                statusLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
                statusLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                statusLabel.heightAnchor.constraint(equalToConstant: 35),
                statusLabel.widthAnchor.constraint(equalToConstant: 200)
            ])
        case .isWaiting:
            statusLabel.removeFromSuperview()
            statusLabel.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(statusLabel)
            statusLabel.text = MainScreenConstants.DriverStatusText.Waiting.rawValue
            statusLabel.textColor = UIColor.black
            statusLabel.textAlignment = .right
            
            containerView.addSubview(waitingDescriptionLabel)
            waitingDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            waitingDescriptionLabel.font = UIFont.SFUIDisplayRegular(size: 12)
            waitingDescriptionLabel.textAlignment = .center
            waitingDescriptionLabel.textColor = UIColor.DarkGrayTextColor
            
            
            
            NSLayoutConstraint.activate([
                statusLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
                statusLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 65),
                statusLabel.heightAnchor.constraint(equalToConstant: 35),
                statusLabel.widthAnchor.constraint(equalToConstant: 170),
                
                waitingDescriptionLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 1),
                waitingDescriptionLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                waitingDescriptionLabel.widthAnchor.constraint(equalToConstant: 330),
                waitingDescriptionLabel.heightAnchor.constraint(equalToConstant: 15)
                
            ])
        case .paidWaiting:
            statusLabel.removeFromSuperview()
            containerView.addSubview(statusLabel)
            statusLabel.translatesAutoresizingMaskIntoConstraints = false
            statusLabel.text = MainScreenConstants.DriverStatusText.PaidWaiting.rawValue
            statusLabel.textColor = UIColor.black
            statusLabel.textAlignment = .right
            
            containerView.addSubview(waitingDescriptionLabel)
            waitingDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            waitingDescriptionLabel.font = UIFont.SFUIDisplayRegular(size: 12)
            waitingDescriptionLabel.textAlignment = .center
            waitingDescriptionLabel.textColor = UIColor.DarkGrayTextColor
            
            
            
            NSLayoutConstraint.activate([
                statusLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
                statusLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
                statusLabel.heightAnchor.constraint(equalToConstant: 35),
                statusLabel.widthAnchor.constraint(equalToConstant: 290),
                
                waitingDescriptionLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 1),
                waitingDescriptionLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                waitingDescriptionLabel.widthAnchor.constraint(equalToConstant: 330),
                waitingDescriptionLabel.heightAnchor.constraint(equalToConstant: 15)
                
            ])
        }
        
    }
    
    func configureTimeLabel(with state: DriverStatus){
        timeLabel.font = UIFont.SFUIDisplayRegular(size: 28)
        switch state {
        case .onTheWay:
            
            containerView.addSubview(timeLabel)
         
            timeLabel.textColor = UIColor.saleOrangeColor
            timeLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                timeLabel.topAnchor.constraint(equalTo: statusLabel.topAnchor),
                timeLabel.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor, constant: 10),
                timeLabel.heightAnchor.constraint(equalToConstant: 35),
                timeLabel.widthAnchor.constraint(equalToConstant: 100)
            ])
        case .almostThere:
            timeLabel.removeFromSuperview()
        case .arrived:
            timeLabel.removeFromSuperview()
        case .isWaiting:
           
            containerView.addSubview(timeLabel)
        
            timeLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                timeLabel.topAnchor.constraint(equalTo: statusLabel.topAnchor),
                timeLabel.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor, constant: 10),
                timeLabel.heightAnchor.constraint(equalToConstant: 35),
                timeLabel.widthAnchor.constraint(equalToConstant: 100)
            ])
        case .paidWaiting:
            timeLabel.removeFromSuperview()
            containerView.addSubview(timeLabel)
        
            timeLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                timeLabel.topAnchor.constraint(equalTo: statusLabel.topAnchor),
                timeLabel.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor, constant: 8),
                timeLabel.heightAnchor.constraint(equalToConstant: 35),
                timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
            ])
        }
        
    }
    
    func configureNameAndNumberViews(state: DriverStatus){
        
        var topPadding = CGFloat()
        
        switch state{
        case .onTheWay:
            topPadding = 50
        case .almostThere:
            topPadding = 50
        case .arrived:
            topPadding = 55
        case .isWaiting:
            topPadding = 65
            carNameLabel.removeFromSuperview()
        case .paidWaiting:
            topPadding = 65
            carNameLabel.removeFromSuperview()
        }
        
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
            carNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: topPadding),
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
            callView.removeFromSuperview()
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
            onMyWayView.removeFromSuperview()
            containerView.addSubview(callView)
            callView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                callView.topAnchor.constraint(equalTo: carNumberView.bottomAnchor, constant: 20),
                callView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                callView.heightAnchor.constraint(equalToConstant: 72),
                callView.widthAnchor.constraint(equalToConstant: 82)
            ])
        case .paidWaiting:
            return
        }
    }
    

}
