//
//  UserDefaultsModel.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 13.06.2021.
//

import Foundation

//Модель данных для UserDeaults
final class UserDefaultsModel: NSObject, NSCoding {

    var userLanguage: String
    
    init(language: String) {
        self.userLanguage = language
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(userLanguage, forKey: UserDefaultKeys.language.rawValue)
    }
    
    required init?(coder: NSCoder) {
        userLanguage = coder.decodeObject(forKey: UserDefaultKeys.language.rawValue) as? String ?? "rus"
    }
}
