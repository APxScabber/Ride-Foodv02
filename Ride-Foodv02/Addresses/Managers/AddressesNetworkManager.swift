//
//  AddressesNetworkManager.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 03.08.2021.
//

import Foundation

class AddressesNetworkManager {
    static let shared = AddressesNetworkManager()
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
    
    
    func getTheAddresses(completion: @escaping (Result<[AddressData], Error>) -> Void){
      
        guard let id = getUserID() else {
            completion(.failure(DataError.invalideData))
            return
        }
                
                let endPoint = self.baseURL + "/api/user/\(id)/address"
                
                guard let url = URL(string: endPoint) else {
                    completion(.failure(DataError.invalideData))
                    return
                }
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    
                    if let _ = error {
                        completion(.failure(DataError.invalideData))
                    }
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        print(error?.localizedDescription ?? DataError.invalideResponse)
                        completion(.failure(DataError.invalideResponse))
                        return
                    }
                    
                    guard let data = data else {
                        completion(.failure(DataError.invalideData))
                        return
                    }
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        guard let dict = json as? [String: Any] else {return}
                        let addressesData = dict["data"] as? [[String: Any]]
                        var addresses = [AddressData]()
                        addressesData?.forEach({ element in
                            let address = AddressData(
                                id: element["id"] as? Int,
                                name: element["name"] as? String,
                                address: element["address"] as? String,
                                commentDriver: element["comment_driver"] as? String,
                                commentCourier: element["comment_courier"] as? String,
                                flat: element["flat"] as? Int,
                                intercom: element["intercom"] as? Int,
                                entrance: element["entrance"] as? Int,
                                floor: element["floor"] as? Int,
                                destination: element["destination"] as? Bool)
                            addresses.append(address)
                        })
                        completion(.success(addresses))
                    }
                    catch {
                        print(error.localizedDescription)
                        completion(.failure(DataError.decodingError))
                    }
                    
                }
                task.resume()
            
    }
    
        
    
    
    func prepareAddressForSending(address: AddressData?) -> [String: Any]{
        var dictionaryToReturn = [String: Any]()
        guard let data = address else { return dictionaryToReturn }
        dictionaryToReturn = [
            "name": data.name ?? "",
            "address": data.address ?? "",
            "comment_driver": data.commentDriver ?? "",
            "comment_courier": data.commentCourier ?? "",
            "flat": data.flat ?? 0,
            "intercom": data.intercom ?? 0,
            "entrance": data.entrance ?? 0 ,
            "floor": data.floor ?? 0 ,
            "destination": data.destination ?? false
        ]
        return dictionaryToReturn
    }
    
    
    func sendAddressToTheServer(addressToPass: [String: Any], completion: @escaping (Result<[AddressData], Error>)-> Void){
        
        guard let id = getUserID() else {
            completion(.failure(DataError.invalideData))
            return
        }
        
      
        let JSONData = try? JSONSerialization.data(withJSONObject: addressToPass)
                
                
                let endPoint = self.baseURL + "/api/user/\(id)/address"
                
                guard let url = URL(string: endPoint) else {
                    completion(.failure(DataError.invalideData))
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = JSONData
               request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    
                    if let _ = error {
                        completion(.failure(DataError.invalideData))
                    }
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        print(response)
                        completion(.failure(DataError.invalideResponse))
                        return
                    }
                    
                    guard let data = data else {
                        completion(.failure(DataError.invalideData))
                        return
                    }
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        guard let dict = json as? [String: Any] else {return}
                        let addressesData = dict["data"] as? [[String: Any]]
                        var addresses = [AddressData]()
                        addressesData?.forEach({ element in
                            let address = AddressData(
                                id: element["id"] as? Int,
                                name: element["name"] as? String,
                                address: element["address"] as? String,
                                commentDriver: element["comment_driver"] as? String,
                                commentCourier: element["comment_courier"] as? String,
                                flat: element["flat"] as? Int,
                                intercom: element["intercom"] as? Int,
                                entrance: element["entrance"] as? Int,
                                floor: element["floor"] as? Int,
                                destination: element["destination"] as? Bool)
                            addresses.append(address)
                        })
                        completion(.success(addresses))
                    }
                    catch {
                        print(error.localizedDescription)
                        completion(.failure(DataError.decodingError))
                    }
                    
                }
                task.resume()
            
           
            
            
        }
    
    
    
    func deleteAddressFromServer(AddressID: Int, completion: @escaping (Result<[AddressData],  Error>)-> Void){
        
        guard let id = getUserID() else {
            completion(.failure(DataError.invalideData))
            return
        }
        let endPoint = self.baseURL + "/api/user/\(id)/address/\(AddressID)"
        
        guard let url = URL(string: endPoint) else {
            completion(.failure(DataError.invalideData))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ = error {
                completion(.failure(DataError.invalideData))
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print(response)
                completion(.failure(DataError.invalideResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(DataError.invalideData))
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                guard let dict = json as? [String: Any] else {return}
                let addressesData = dict["data"] as? [[String: Any]]
                var addresses = [AddressData]()
                addressesData?.forEach({ element in
                    let address = AddressData(
                        id: element["id"] as? Int,
                        name: element["name"] as? String,
                        address: element["address"] as? String,
                        commentDriver: element["comment_driver"] as? String,
                        commentCourier: element["comment_courier"] as? String,
                        flat: element["flat"] as? Int,
                        intercom: element["intercom"] as? Int,
                        entrance: element["entrance"] as? Int,
                        floor: element["floor"] as? Int,
                        destination: element["destination"] as? Bool)
                    addresses.append(address)
                })
                completion(.success(addresses))
            }
            catch {
                print(error.localizedDescription)
                completion(.failure(DataError.decodingError))
            }
            
        }
        task.resume()
        
    }
    
    func updateAddress(AddressID: Int, changesToPass: [String: Any], completion: @escaping (Result<[AddressData], Error>)-> Void){
        
        guard let id = getUserID() else {
            completion(.failure(DataError.invalideData))
            return
        }
        let JSONData = try? JSONSerialization.data(withJSONObject: changesToPass)
        
        let endPoint = self.baseURL + "/api/user/\(id)/address/\(AddressID)"
        
        guard let url = URL(string: endPoint) else {
            completion(.failure(DataError.invalideData))
            return
        }
      
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = JSONData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ = error {
                completion(.failure(DataError.invalideData))
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print(response)
                completion(.failure(DataError.invalideResponse))
                return
            }
            print(response.statusCode)
            guard let data = data else {
                completion(.failure(DataError.invalideData))
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                guard let dict = json as? [String: Any] else {return}
                let addressesData = dict["data"] as? [[String: Any]]
                var addresses = [AddressData]()
                addressesData?.forEach({ element in
                    let address = AddressData(
                        id: element["id"] as? Int,
                        name: element["name"] as? String,
                        address: element["address"] as? String,
                        commentDriver: element["comment_driver"] as? String,
                        commentCourier: element["comment_courier"] as? String,
                        flat: element["flat"] as? Int,
                        intercom: element["intercom"] as? Int,
                        entrance: element["entrance"] as? Int,
                        floor: element["floor"] as? Int,
                        destination: element["destination"] as? Bool)
                    addresses.append(address)
                })
                print(addresses)
                completion(.success(addresses))
            }
            catch {
                print(error.localizedDescription)
                completion(.failure(DataError.decodingError))
            }
            
        }
        task.resume()
        
        
        
        
    }
    
}

