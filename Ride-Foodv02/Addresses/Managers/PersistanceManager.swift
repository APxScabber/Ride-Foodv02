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
    
    func deleteData() {
       
       
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserAddressMO")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for managedObject in results {
                if let managedObjectData: NSManagedObject = managedObject as? NSManagedObject {
                    context.delete(managedObjectData)
                }
            }
        } catch let error as NSError {
            print("Deleted all my data in myEntity error : \(error) \(error.userInfo)")
        }
    }
    
    
    
}
