import Foundation


class ShopDetailFetcher {
    
    static func fetch(shopID:Int,_ completion: @escaping ( (ShopDetail) -> Void)) {
        
        CoreDataManager.shared.fetchCoreData { result in
        switch result {
            case .success(let model):
                let userData = model.first
                guard let id = userData?.id as? Int else { return }
                let urlString = "https://skillbox.cc/api/user/\(id)/shop/\(shopID)"
                if let url = URL(string: urlString) {
                    DispatchQueue.global(qos: .userInitiated).async {
                        let session = URLSession(configuration: .default)
                        let request = URLRequest(url: url)
                        let task = session.dataTask(with: request) { data, responce, error in
                            if let data = data,
                               let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                               let dict = json as? [String:Any],
                               let dataFromDict = dict["data"] as? [String:Any],
                               let id = dataFromDict["id"] as? Int,
                               let name = dataFromDict["name"] as? String,
                               let schedule = dataFromDict["schedule"] as? String ,
                               let description = dataFromDict["description"] as? String,
                               let address = dataFromDict["address"] as? String,
                               let iconURL = dataFromDict["icon"] as? String,
                               let categories = dataFromDict["categories"] as? [[String:Any]]{
                                var foundCategories = [ShopDetail.Category]()
                                categories.forEach {
                                    if let id = $0["id"] as? Int,
                                       let name = $0["name"] as? String,
                                       let icon = $0["icon"] as? String {
                                        foundCategories.append(ShopDetail.Category(id: id, name: name, iconURL: icon))
                                    }
                                }
                                let shopDetail = ShopDetail(id: id, name: name, schedule: schedule, description: description, address: address, iconURL: iconURL, categories: foundCategories)
                                DispatchQueue.main.async {
                                    completion(shopDetail)
                                }
                            }
                        }
                        task.resume()
                    }
                }
        default:break
        }
        }
        
    }
}
