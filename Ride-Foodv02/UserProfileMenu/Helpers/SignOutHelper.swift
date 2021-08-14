//
//  SignOutHelper.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 14.08.2021.
//

import UIKit
import CoreData

class SignOutHelper{
    static let shared = SignOutHelper()
    
    private init() {
    }
    
    let context = CoreDataManager.shared.persistentContainer.viewContext
    
    func resetUserDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
       
    }
    
    func resetCoreDataEntity(with entityName: String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for managedObject in results {
                if let managedObjectData: NSManagedObject = managedObject as? NSManagedObject {
                    context.delete(managedObjectData)
                    try context.save()
                }
            }
          
        } catch let error as NSError {
            print("Deleted all my data in myEntity error : \(error) \(error.userInfo)")
        }
    }
    
    func resetCoreDataEntities(){
        resetCoreDataEntity(with: "UserAddressMO")
        resetCoreDataEntity(with: "UserDataMO")
        resetCoreDataEntity(with: "UserSettingsMO")
    }
    
    func resetEverything(){
        resetUserDefaults()
        resetCoreDataEntities()
       
    }
}
