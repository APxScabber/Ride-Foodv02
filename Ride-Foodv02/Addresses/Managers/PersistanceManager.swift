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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchAddresses(completion: @escaping (Result<[UserAddressMO], Error>) -> Void){
        do {
            let addresses = try! context.fetch(UserAddressMO.fetchRequest()) as [UserAddressMO]
            completion(.success(addresses))
        } catch {
            completion(.failure(error ))
        }
    }
    
    
    
    
    
}