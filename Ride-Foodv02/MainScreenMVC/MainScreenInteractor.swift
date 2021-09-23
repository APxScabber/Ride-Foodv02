//
//  MainScreenInteractor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 20.09.2021.
//

import CoreLocation
import MapKit
import UIKit

class MainScreenInteractor {
    
    
    // Загрузка адресов с сервера с последующим сохранением в Core Data
    func getAdressesFromServer(view: UIViewController) {
        
        AddressesNetworkManager.shared.getTheAddresses { result in
            
            switch result {
            case .success(let adressesData):
    
                PersistanceManager.shared.createCoreDataInstance(addressesToCopy: adressesData, view: view)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //Получаем координаты из прописного адреса
    func getCoordinates(from address: String, to map: MKMapView, completion: @escaping ((String) -> ())) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { placemarks, error in
            guard let placemarks = placemarks, let location = placemarks.first?.location else { return }
            
            SetMapMarkersManager.shared.setMarkOn(map: map, with: location.coordinate) { address in
                completion(address)
            }
        }
    }
    
    // MARK: - Setup UI SetToLocationView
    func setupLocation(view: UIView, for controller: UIView) {
        if let view = view as? SetToLocationView {
            view.frame.size = CGSize(width: controller.frame.width, height: 200)
            view.frame.origin.y = controller.frame.height
                
            view.layer.cornerRadius = controller.frame.width / 16
            view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 1
            view.layer.shadowOffset = .zero
            view.layer.shadowRadius = 10
            
            view.layer.cornerRadius = 15
            view.confirmButton.layer.cornerRadius = 15
            view.confirmButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17.0)
            view.confirmButton.setTitleColor(.white, for: .normal)
            view.confirmButton.backgroundColor = .blue
            view.confirmButton.setTitle(Localizable.Food.confirm.localized, for: .normal)
            
            view.locationTextField.text = ""
        }
    }
    
    // MARK: - Setup UI Food Order View
    func setup(view: UIView, for controller: UIView) {

        let height:CGFloat = 169
        let posY = controller.frame.height
        let width = controller.bounds.width

        view.frame = CGRect(x: 0, y: posY, width: width, height: height)
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 20
        
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        
        view.alpha = 1

        controller.addSubview(view)
    }
    
    // MARK: - TaxiOrderedView Animation
    func animationTaxiOrderInfoLowPart(for view: UIView) {
        animationCarModelLabel(for: view)
        animationCarNumberStackView(for: view)
        animationDriverTextView(for: view)
        animationAddDeliveryButton(for: view)
        animationProblemButton(for: view)
        view.layoutIfNeeded()
    }
    
    private func animationCarModelLabel(for view: UIView) {
        if let view = view as? TaxiOrderInfo {
            if view.carModelHeightConstraint.constant != 0 {
                
                view.carModelHeightConstraint.constant = 0
                view.carModelTopConstraint.constant = 0
                view.carModelLabel.alpha = 0
            } else {
                view.carModelHeightConstraint.constant = 21
                view.carModelTopConstraint.constant = 21
                view.carModelLabel.alpha = 1
            }
        }
    }
    
    private func animationCarNumberStackView(for view: UIView) {
        if let view = view as? TaxiOrderInfo {
            if view.carNumberHeightConstraint.constant != 0 {
                
                view.carNumberHeightConstraint.constant = 0
                view.carNumberTopConstraint.constant = 0
                view.carNumberStackView.alpha = 0
            } else {
                view.carNumberHeightConstraint.constant = 21
                view.carNumberTopConstraint.constant = 6
                view.carNumberStackView.alpha = 1
            }
        }
    }
    
    private func animationDriverTextView(for view: UIView) {
        if let view = view as? TaxiOrderInfo {
            if view.driverHeightConstrint.constant != 0 {
                
                view.driverHeightConstrint.constant = 0
                view.driverTopConstraint.constant = 0
                view.carDriverTextView.alpha = 0
            } else {
                view.driverHeightConstrint.constant = 18
                view.driverTopConstraint.constant = 7
                view.carDriverTextView.alpha = 1
            }
        }
    }
    
    private func animationAddDeliveryButton(for view: UIView) {
        if let view = view as? TaxiOrderInfo {
            if view.addDeliveryHeightConstraint.constant != 0 {
                
                view.addDeliveryHeightConstraint.constant = 0
                view.addDeliveryTopCostraint.constant = 0
                view.addDeliveryButtonOutlet.alpha = 0
            } else {
                view.addDeliveryHeightConstraint.constant = 50
                view.addDeliveryTopCostraint.constant = 25
                view.addDeliveryButtonOutlet.alpha = 1
            }
        }
    }
    
    private func animationProblemButton(for view: UIView) {
        if let view = view as? TaxiOrderInfo {
            if view.problemHeightConstraint.constant != 0 {
                
                view.problemHeightConstraint.constant = 0
                view.problemTopConstraint.constant = 0
                view.problemButtonOutlet.alpha = 0
            } else {
                view.problemHeightConstraint.constant = 35
                view.problemTopConstraint.constant = 12
                view.problemButtonOutlet.alpha = 1
            }
        }
    }
    
    //MARK: - FoodOrderView Animations
    
    func animationFoodOrderInfoLowPart(for view: UIView) {
        animationCourierTextView(for: view)
        animationCallButton(for: view)
        animationCancelButton(for: view)
        view.layoutIfNeeded()
    }
    
    private func animationCourierTextView(for view: UIView) {
        if let view = view as? FoodOrderInfo {
            if view.courierHeightConstrint.constant != 0 {
                
                view.courierHeightConstrint.constant = 0
                view.courierTopConstraint.constant = 0
                view.courierTextView.alpha = 0
            } else {
                view.courierHeightConstrint.constant = 18
                view.courierTopConstraint.constant = 10
                view.courierTextView.alpha = 1
            }
        }
    }
    
    private func animationCallButton(for view: UIView) {
        if let view = view as? FoodOrderInfo {
            if view.callHeightConstraint.constant != 0 {
                
                view.callHeightConstraint.constant = 0
                view.callTopCostraint.constant = 0
                view.callButtonOutlet.alpha = 0
            } else {
                view.callHeightConstraint.constant = 50
                view.callTopCostraint.constant = 25
                view.callButtonOutlet.alpha = 1
            }
        }
    }
    
    private func animationCancelButton(for view: UIView) {
        if let view = view as? FoodOrderInfo {
            if view.cancelHeightConstraint.constant != 0 {
                
                view.cancelHeightConstraint.constant = 0
                view.cancelTopConstraint.constant = 0
                view.cancelButtonOutlet.alpha = 0
            } else {
                view.cancelHeightConstraint.constant = 35
                view.cancelTopConstraint.constant = 12
                view.cancelButtonOutlet.alpha = 1
            }
        }
    }
    
    // MARK: - Swipe Animations
    
    
    
    func getTaxiTariffImage(index: Int) -> UIImage? {
        switch index {
        case 0:
            return #imageLiteral(resourceName: "StandartCar")
        case 1:
            return #imageLiteral(resourceName: "PremiumCar")
        case 2:
            return #imageLiteral(resourceName: "BusinessCar")
        default:
            return nil
        }
    }
    
}
