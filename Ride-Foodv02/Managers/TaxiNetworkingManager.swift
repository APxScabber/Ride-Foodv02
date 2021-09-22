//
//  TaxiNetworkingManager.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 17.09.2021.
//

import UIKit

class TaxiNetworkingManager{
    static let shared = TaxiNetworkingManager()
    private let baseURL = "https://skillbox.cc"
    
    
    func searchForDrivers(id: Int, tariff: Int, from: String, to: String, paymentCard: Int, paymentMethod: String, promoCodes: [String], credit: Int, completion: @escaping(Result<OrderData, VBError>) -> Void){
        
        
        let infoToPass: [String: Any] = [
            "tariff": tariff,
            "from": from,
            "to": to,
            "payment_card": paymentCard,
            "payment_method": paymentMethod,
            "promo_codes": promoCodes,
            "credit": credit
        ]
        
        guard let JSONData = try? JSONSerialization.data(withJSONObject: infoToPass) else {
            completion(.failure(.invalidData))
          
            return
        }
            let endPoint            = self.baseURL + "/api/user/\(id)/order/taxi"
            
            guard let url           = URL(string: endPoint) else {
                completion(.failure(.invalidData))
                return
            }
            var request             = URLRequest(url: url)
        request.httpMethod          = "POST"
        request.httpBody            = JSONData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ = error {
                completion(.failure(.invalidData))
            }
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                      print(response!)
                    completion(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let order = try decoder.decode(OrderData.self, from: data)
                completion(.success(order))
            }
            catch {
                print(error.localizedDescription)
                completion(.failure(.invalidData))
            }
        }
        task.resume()
        }
    }



