//
//  UserDefaultsManager.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 13.06.2021.
//

import Foundation

//Класс для работы с UserDefaults
class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private init() {
        
    }
    
    //Сохраняем и получаем из UserDefaults настройки пользователя
    var userSettings: UserDefaultsModel! {
        get {
            guard let savedData = UserDefaults.standard.object(
                    forKey: UserDefaultKeys.userSettings.rawValue) as? Data,
                   let decodedModel = try? NSKeyedUnarchiver
                    .unarchiveTopLevelObjectWithData(savedData) as? UserDefaultsModel else
            { return UserDefaultsModel(language: UserDefaultLanguage.eng.rawValue) }
            // TODO: - Надо возвращать нужный вариант, а не подставлять в ручную
            return decodedModel
        }
        set {
            let defaults = UserDefaults.standard
            let key = UserDefaultKeys.userSettings.rawValue
            
            if let userModel = newValue {
                if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: userModel,
                                                                     requiringSecureCoding: false) {
                    defaults.set(savedData, forKey: key)
                }
            }
        }
    }
    
    func getLanguage() -> String {
        let userSettings = UserDefaultsManager.shared.userSettings
        guard let languageCode = userSettings?.userLanguage else { return "rus" }
        return languageCode
    }
//    
//    var newCardsData: [CardsUserDefaultsModel]! {
//        get {
//            
//            guard let savedData = UserDefaults.standard.object(
//                    forKey: NewCardsDataKey.newCard.rawValue) as? Data,
//                  let decodedModel = try? NSKeyedUnarchiver
//                   .unarchiveTopLevelObjectWithData(savedData) as? [CardsUserDefaultsModel] else
//                    { return [] }
//                
//
//            return decodedModel
//            
//        }
//        set {
//            let defaults = UserDefaults.standard
//            let key = NewCardsDataKey.newCard.rawValue
//            
//            if let userModel = newValue {
//                if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: userModel,
//                                                                     requiringSecureCoding: false) {
//                    defaults.set(savedData, forKey: key)
//                }
//            }
//        }
//    }
}
