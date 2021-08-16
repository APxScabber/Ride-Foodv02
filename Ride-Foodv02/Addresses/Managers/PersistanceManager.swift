//
//  PersistanceManager.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 21.07.2021.
//

import UIKit
import CoreData

class PersistanceManager {
    
    static let shared = PersistanceManager()
    
    private init() {
    }
    
    let context = CoreDataManager.shared.persistentContainer.viewContext
    
    func fetchAddresses(completion: @escaping (Result<[UserAddressMO], Error>) -> Void){
        do {
            let addresses = try! context.fetch(UserAddressMO.fetchRequest()) as [UserAddressMO]
            completion(.success(addresses))
        } 
    }
    
    func addNewAddress(address: UserAddressMO){
        do {
            try self.context.save()
        } catch let error {
            print(error)
        }
    }
    
    func createCoreDataInstance(addressesToCopy: [AddressData]?, view: UIViewController){
        SignOutHelper.shared.resetCoreDataEntity(with: "UserAddressMO")
        
        
        
        
        guard let data = addressesToCopy else {
            return
        }
        for i in data{
            let localAddress = UserAddressMO(context: PersistanceManager.shared.context)
           
            localAddress.id = view.placeIntIntoString(int: i.id ?? 0)
            localAddress.title = i.name
            localAddress.fullAddress = i.address
            localAddress.driverCommentary = i.commentDriver
            localAddress.delivApartNumber = view.placeIntIntoString(int: i.flat ?? 0)
            localAddress.delivIntercomNumber = view.placeIntIntoString(int: i.intercom ?? 0)
            localAddress.delivEntranceNumber = view.placeIntIntoString(int: i.entrance ?? 0)
            localAddress.delivFloorNumber = view.placeIntIntoString(int: i.floor ?? 0)
            localAddress.deliveryCommentary = i.commentCourier
            localAddress.isDestination = i.destination ?? false
            
            PersistanceManager.shared.addNewAddress(address: localAddress)
            
        }
   
    }
    
    
    
}
