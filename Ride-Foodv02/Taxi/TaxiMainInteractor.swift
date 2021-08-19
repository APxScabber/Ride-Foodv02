//
//  TaxiMainInteractor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 16.08.2021.
//

import CoreLocation
import UIKit
import MapKit

class TaxiMainInteractor {
    
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
}
