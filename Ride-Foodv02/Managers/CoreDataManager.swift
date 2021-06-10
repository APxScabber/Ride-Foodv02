//
//  CoreDataManager.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 10.06.2021.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var userData: UserDataMO?
    
    func loadDefaultData() {
        
        let fetchRequest: NSFetchRequest<UserDataMO> = UserDataMO.fetchRequest()
        
        var records = 0
        
        do {
            let count = try context.count(for: fetchRequest)
            records = count
            
        } catch {
            print(error.localizedDescription)
        }
        print("Records: \(records)")
        
        guard records == 0 else {
            print("is not Empty")
            return }
        
        

        
        let pathToFile = Bundle.main.path(forResource: "DefaultUserData", ofType: "plist")
        let defaultData = NSDictionary(contentsOfFile: pathToFile!)!
        
//        do {
//            let result = try context.fetch(fetchRequest)
//            if result.isEmpty {
//                print("Result is Empty")
//            } else {
//                print(result)
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
        
//        let entity = NSEntityDescription.entity(forEntityName: "UserDataMO", in: context)
//        let user = NSManagedObject(entity: entity!, insertInto: context) as! UserDataMO
//
//        let userSettings = defaultData["settings"] as! NSDictionary
//
//        user.id = defaultData["id"] as! Int
//        user.name = defaultData["name"] as? String
//        user.email = defaultData["email"] as? String
//        user.create_at = defaultData["create_at"] as! Int
//        user.update_at = defaultData["update_at"] as! Int
//        user.delete_at = defaultData["delete_at"] as! Int
//
//        user.settings?.language = userSettings["language"] as? String
//        user.settings?.do_not_call = userSettings["do_not_call"] as! Bool
//        user.settings?.notification_discount = userSettings["notification_discount"] as! Bool
//        user.settings?.update_mobile_network = userSettings["update_mobile_network"] as! Bool
//
//        print("All data saved")
    }
    
}
