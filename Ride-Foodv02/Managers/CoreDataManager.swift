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
    #warning("Что-то тут с потоками, все работало, а потом перестало")
    //var context: NSManagedObjectContext!
    var userSettings: UserSettingsMO!
    var userData: UserDataMO!
    
    private lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //var context2: NSManagedObjectContext!
    
    
//    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    

//    init() {
//
////        context = appDelegate.persistentContainer.newBackgroundContext()
//
//
//        DispatchQueue.main.async {
//            self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//            //self.context2 = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//            print("Context init")
//        }
//    }
    
    //MARK: - Methods
    
    //Метод загрузки данных из Core Data
    func fetchCoreData(completion: @escaping ((Result<[UserDataMO], Error>)?) -> Void) {
       // print("fetch Method")

        //let result = try! context.fetch(fetchRequest)
        //DispatchQueue.main.async { [weak self] in
            
            
//            let backgroundContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
//            backgroundContext.parent = self?.context
            
            do {
                //print("context in fetch")
                
                let fetchRequest: NSFetchRequest<UserDataMO> = UserDataMO.fetchRequest()
                let result = try! context.fetch(fetchRequest)
                
                //let fetchRequest: NSFetchRequest<UserDataMO> = UserDataMO.fetchRequest()

                if result.isEmpty {

                    let userDefaultSettings = UserDefaultsManager.userSettings
                    let language = userDefaultSettings?.userLanguage
                    
                    userSettings = UserSettingsMO(context: context)
                    
                    userSettings.language = language
                    userSettings.do_not_call = false
                    userSettings.notification_discount = false
                    userSettings.update_mobile_network = false
                    
                    userData = UserDataMO(context: context)
                    
                    userData.id = nil
                    userData.name = ""
                    userData.email = ""
                    userData.create_at = nil
                    userData.update_at = nil
                    userData.delete_at = nil
                    
                    userData.settings = userSettings
                    
                    try context.save()
                    
                } else {
                    
                completion(.success(result))
                    
                }
            } catch {
            
                completion(.failure(error))
                
            }
        //}
    }
    
    //Мкетод сохранения данных в Core Data
    func saveCoreData(model: ConfirmModel) {
        
//        let userData = UserDataMO(context: context)
//        let userSettings = UserSettingsMO(context: context)
        //print("save method")
        //DispatchQueue.main.async { [weak self] in
            
            userData = UserDataMO(context: context)
            userSettings = UserSettingsMO(context: context)
            //print("context in save Method")
            userSettings.language = model.setting?.language
            userSettings.do_not_call = ((model.setting?.do_not_call) != nil)
            userSettings.notification_discount = ((model.setting?.notification_discount) != nil)
            userSettings.update_mobile_network = ((model.setting?.update_mobile_network) != nil)
            
            userData.id = NSNumber(value: model.id)
            userData.name = model.name
            userData.email = model.email
            userData.create_at = NSNumber(value: model.created_at ?? 0)
            userData.update_at = NSNumber(value: model.updated_at ?? 0)
            userData.delete_at = NSNumber(value: model.deleted_at ?? 0)

            userData.settings = userSettings
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        //}
    }
}
