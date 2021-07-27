import Foundation


class ShopFetcher {
    
    
    static func fetch(_ completion: @escaping ( (([Shop]) -> Void) )) {
        
        var foundShops = [Shop]()
        
        CoreDataManager.shared.fetchCoreData { result in
        switch result {
            case .success(let model):
                let userData = model.first
                guard let id = userData?.id as? Int else { return }
                let urlString = "https://skillbox.cc/api/user/\(id)/shops"
                if let url = URL(string: urlString) {
                    DispatchQueue.global(qos: .userInitiated).async {
                        let request = URLRequest(url: url)
                        let session = URLSession(configuration: .default)
                        let task = session.dataTask(with: request) { data, responce, error in
                            if let data = data,
                               let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                               let dict = json as? [String:Any],
                               let shops = dict["data"] as? [[String:Any]] {
                                shops.forEach {
                                    if let id = $0["id"] as? Int,
                                       let name = $0["name"] as? String,
                                       let icon = $0["icon"] as? String{
                                        let shop = Shop(id: id, name: name, iconURL: icon)
                                        foundShops.append(shop)
                                    }
                                }
                                DispatchQueue.main.async {
                                    completion(foundShops)
                                }
                            }
                        }
                        task.resume()
                    }
                }
            default: break
            }
        }
    }
}
