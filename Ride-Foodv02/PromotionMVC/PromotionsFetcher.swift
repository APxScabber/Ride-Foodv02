import Foundation

class PromotionsFetcher {
    
    static func fetch(_ type:PromotionType, completion: @escaping ( ([Promotion]) -> () )) {
        var promotions = [Promotion]()
        CoreDataManager.shared.fetchCoreData { result in
        switch result {
            case .success(let model):
                let userData = model.first
                if let id = userData?.id as? Int {
                    let urlString = "https://skillbox.cc/api/user/\(id)/promotions/\(type.rawValue)?page=1&per_page=20"
                    if let url = URL(string: urlString) {
                        DispatchQueue.global(qos: .userInitiated).async {
                            let session = URLSession(configuration: .default)
                            let request = URLRequest(url: url)
                            let task = session.dataTask(with: request ) { data,responce,error in
                                if let data = data,
                                   let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                                   let dict = json as? [String:Any],
                                   let data = dict["data"] as? [[String:Any]]{
                                    data.forEach {
                                        var promotion = Promotion()
                                        if let id = $0["id"] as? Int,
                                           let title = $0["title"] as? String,
                                           let media = $0["media"] as? [[String:Any]] {
                                            media.forEach { media in
                                                if let url = media["url"] as? String {
                                                    promotion.imagesURL.append(url)
                                                }
                                            }
                                            promotion.id = id
                                            promotion.title = title
                                            promotions.append(promotion)
                                        }
                                    }
                                    DispatchQueue.main.async {
                                        completion(promotions)
                                    }
                                }
                            }
                            task.resume()
                        }
                    }
                }
            default: break
        }
    }
    }
    
     enum PromotionType: String {
        case food = "food"
        case taxi = "taxi"
    }
    
}
