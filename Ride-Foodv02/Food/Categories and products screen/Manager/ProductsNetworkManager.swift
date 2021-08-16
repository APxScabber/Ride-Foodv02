//
//  ProductsNetworkManager.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 17.08.2021.
//

import Foundation

class ProductsNetworkManager {
    static let shared = ProductsNetworkManager()
    
    private let baseURL = "https://skillbox.cc"
    
    func getUserID() -> Int?{
        var idToReturn = Int()
        CoreDataManager.shared.fetchCoreData { result in
            switch result{
            case .failure(let error):
                print(error)
                break
                
            case .success(let data):
                guard let id = data.first?.id as? Int else {
                    break
                }
                idToReturn = id
            case .none:
                break
            }
        }
        return idToReturn
    }
    
    func getProducts(shopID: Int, parentCategoryID: Int, page: Int, completion: @escaping (Result<ProductData, VBError>) -> Void){
        
        guard let id = getUserID() else {
            completion(.failure(.invalidUsername))
            return
        }
        
        let endPoint = baseURL + "/api/user/\(id)/shop/\(shopID)/products/\(parentCategoryID)?page=\(page)"
        
        guard let url = URL(string: endPoint) else {
            completion(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
               let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let products = try decoder.decode(ProductData.self, from: data)
                completion(.success(products))
            }
            catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    
}
