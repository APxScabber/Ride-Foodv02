//
//  GetUserIDManager.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 13.08.2021.
//

import Foundation

class GetUserIDManager {
    
    static let shared = GetUserIDManager()
    
    init() {
    }
    
    var userID: String?
    
    //Получаем ID пользователя для дальнейшего использования в запросах к серверу
    func getUserID() {
        
        CoreDataManager.shared.fetchCoreData { [weak self] result in
            
            switch result {
            case .success(let model):
                let userData = model.first
                self?.userID = String(describing: userData!.id!)
            case .failure(let error):
                print(error)
            case .none:
                return
            }
        }
    }
}
