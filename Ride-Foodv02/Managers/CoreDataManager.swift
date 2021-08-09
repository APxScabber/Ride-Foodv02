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
    
    static var shared = CoreDataManager()
    var isLogin: Bool?
    
    private lazy var context = persistentContainer.viewContext
    
    private init() {
    }

    //MARK: - Methods
    
    //Метод загрузки данных из Core Data
    func fetchCoreData(completion: @escaping ((Result<[UserDataMO], Error>)?) -> Void) {
        
        let fetchContext = CoreDataManager.shared.context

                let fetchRequest: NSFetchRequest<UserDataMO> = UserDataMO.fetchRequest()
                let result = try! fetchContext.fetch(fetchRequest)

                if result.isEmpty {
                    isLogin = false
                } else {
                    isLogin = true
                    completion(.success(result))
                }
    }

    //Мкетод сохранения данных в Core Data
    func saveCoreData(model: ConfirmModel) {
        
        let saveContext = CoreDataManager.shared.context
        
        let userData = UserDataMO(context: saveContext)
        let userSettings = UserSettingsMO(context: saveContext)
        
        userSettings.language = model.setting?.language != nil ? model.setting?.language : "rus"
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
            try saveContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "UserDataModel")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
