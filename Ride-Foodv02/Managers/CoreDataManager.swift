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
    var context: NSManagedObjectContext!
    var userSettings: UserSettingsMO!
    var userData: UserDataMO!
    
    //var context2: NSManagedObjectContext!
    
    
//    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    

    init() {
        
//        context = appDelegate.persistentContainer.newBackgroundContext()
        
        
        DispatchQueue.main.async {
            self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            //self.context2 = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            print("Context init")
        }
    }
    
    //MARK: - Methods
    
    //Метод загрузки данных из Core Data
    func fetchCoreData(completion: @escaping ((Result<[UserDataMO], Error>)?) -> Void) {
        print("fetch Method")
        
        
        let fetchRequest: NSFetchRequest<UserDataMO> = UserDataMO.fetchRequest()
        let result = try! context!.fetch(fetchRequest)
        
        //let result = try! context.fetch(fetchRequest)
        DispatchQueue.main.async { [weak self] in
            
            
//            let backgroundContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
//            backgroundContext.parent = self?.context
            
   
            
            
            
            do {
                print("context in fetch")
                
                
                
                //let fetchRequest: NSFetchRequest<UserDataMO> = UserDataMO.fetchRequest()
                
                
                
                
                if result.isEmpty {

                    let userDefaultSettings = UserDefaultsManager.userSettings
                    let language = userDefaultSettings?.userLanguage
                    
                    self?.userSettings = UserSettingsMO(context: self!.context)
                    
                    self?.userSettings.language = language
                    self?.userSettings.do_not_call = false
                    self?.userSettings.notification_discount = false
                    self?.userSettings.update_mobile_network = false
                    
                    self?.userData = UserDataMO(context: self!.context)
                    
                    self?.userData.id = nil
                    self?.userData.name = ""
                    self?.userData.email = ""
                    self?.userData.create_at = nil
                    self?.userData.update_at = nil
                    self?.userData.delete_at = nil
                    
                    self?.userData.settings = self?.userSettings
                    
                    try self!.context.save()
                    
                } else {
                    completion(.success(result))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    //Мкетод сохранения данных в Core Data
    func saveCoreData(model: ConfirmModel) {
        
//        let userData = UserDataMO(context: context)
//        let userSettings = UserSettingsMO(context: context)
        print("save method")
        DispatchQueue.main.async { [weak self] in
            
            self?.userData = UserDataMO(context: self!.context)
            self?.userSettings = UserSettingsMO(context: self!.context)
            print("context in save Method")
            self?.userSettings.language = model.setting?.language
            self?.userSettings.do_not_call = ((model.setting?.do_not_call) != nil)
            self?.userSettings.notification_discount = ((model.setting?.notification_discount) != nil)
            self?.userSettings.update_mobile_network = ((model.setting?.update_mobile_network) != nil)
            
            self?.userData.id = NSNumber(value: model.id)
            self?.userData.name = model.name
            self?.userData.email = model.email
            self?.userData.create_at = NSNumber(value: model.created_at ?? 0)
            self?.userData.update_at = NSNumber(value: model.updated_at ?? 0)
            self?.userData.delete_at = NSNumber(value: model.deleted_at ?? 0)

            self?.userData.settings = self?.userSettings
            
            do {
                try self?.context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
