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
    
    init() {
        
    }
    
    // MARK: - Methods
    
    //Сохраняем и получаем из UserDefaults настройки пользователя
    var userLanguage: UserDefaultsModel! {
        get {
            guard let savedData = UserDefaults.standard.object(
                    forKey: UserDefaultKeys.userSettings.rawValue) as? Data,
                   let decodedModel = try? NSKeyedUnarchiver
                    .unarchiveTopLevelObjectWithData(savedData) as? UserDefaultsModel else
            { return UserDefaultsModel(language: UserDefaultLanguage.rus.rawValue) }
            
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
    
    var isFirstEnter: Bool {
        get {
            guard let data = UserDefaults.standard.object(forKey: UserDefaultKeys.firstEnter.rawValue) as? Bool else
            { return true }
            
            return data
        }
        set {
            let defaults = UserDefaults.standard
            let key = UserDefaultKeys.firstEnter.rawValue
            
            //if let newData = newValue {
                defaults.setValue(newValue, forKey: key)
            //}
        }
    }
    
    func getLanguage() -> String {
        let userSettings = UserDefaultsManager.shared.userLanguage
        guard let languageCode = userSettings?.userLanguage else { return "rus" }
        return languageCode
    }
}
