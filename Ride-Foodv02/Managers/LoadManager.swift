//
//  LoadManager.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.06.2021.
//

import Foundation
import UIKit

//Класс для работы с API сервера
class LoadManager: NSObject {
    
    static let shared = LoadManager()
    
    func createData(phone: String, completion: @escaping (Result<DataConfirmModel, Error>) -> Void) {
        
        guard  let url = URL(string: "https://skillbox.cc/api/auth/registration") else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let params = ["phone" : phone]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
        urlRequest.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { data, response, error in
            
            guard let data = data else { return }
            
            do {
                
                let json = try JSONDecoder().decode(DataConfirmModel.self, from: data)
                print(json.data.code)
                completion(.success(json))
                
                
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
