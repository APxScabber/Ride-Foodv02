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
    
    typealias result<T> = (Result <T, Error>) -> Void
    
    //Дженерик метода для работы с сервером
    func loadData<T: Decodable>(of type: T.Type, from url: URL, httpMethod: HTTPMethods,
                                passData: [String : String]?,
                                completion: @escaping result<T>) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            //Формируем данные на отправку на сервер
            let params = passData
            
            //Формируем Request запрос
            var urlRequest = URLRequest(url: url)

            urlRequest.httpMethod = httpMethod.rawValue
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let params = params {
                guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
                urlRequest.httpBody = httpBody
            }
            
            let session = URLSession.shared
            session.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
                
                guard let response = response as? HTTPURLResponse else {
                    DispatchQueue.main.async { completion(.failure(DataError.invalideResponse)) }
                    return
                }
                
                if 200 ... 299 ~= response.statusCode {
              
                    if let data = data {
                        
                        do {
                            
                            let decodeData: T = try JSONDecoder().decode(T.self, from: data)
                            DispatchQueue.main.async { completion(.success(decodeData)) }
                        } catch {
                            DispatchQueue.main.async { completion(.failure(DataError.decodingError)) }
                        }
                    } else {
                        DispatchQueue.main.async { completion(.failure(DataError.invalideData)) }
                    }
                } else {
                    DispatchQueue.main.async { completion(.failure(DataError.serverError)) }
                }
            }.resume()
        }
        
    }
}
