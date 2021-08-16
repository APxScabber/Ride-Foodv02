//
//  TaxiMainInteractor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 16.08.2021.
//

import Foundation

class TaxiMainInteractor {
    
    func createCoreDataInstance(addressesToCopy: [AddressData]?){
        SignOutHelper.shared.resetCoreDataEntity(with: "UserAddressMO")
        //Localaddresses.removeAll()
        
        
        
        guard let data = addressesToCopy else {
            return
        }
        for i in data{
            let localAddress = UserAddressMO(context: PersistanceManager.shared.context)
           
            localAddress.id = placeIntIntoString(int: i.id ?? 0)
            localAddress.title = i.name
            localAddress.fullAddress = i.address
            localAddress.driverCommentary = i.commentDriver
            localAddress.delivApartNumber = placeIntIntoString(int: i.flat ?? 0)
            localAddress.delivIntercomNumber = placeIntIntoString(int: i.intercom ?? 0)
            localAddress.delivEntranceNumber = placeIntIntoString(int: i.entrance ?? 0)
            localAddress.delivFloorNumber = placeIntIntoString(int: i.floor ?? 0)
            localAddress.deliveryCommentary = i.commentCourier
            localAddress.isDestination = i.destination ?? false
            
            PersistanceManager.shared.addNewAddress(address: localAddress)
            
        }
   
    }
    

    
    func placeIntIntoString(int: Int) -> String{
        guard int != 0 else {
            return ""
        }
        return "\(int)"
    }
}
