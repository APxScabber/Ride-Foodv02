import Foundation

class PromotionsFetcher {
    
    
    // ловит список акций с сервера
    
    static func fetch(_ type:PromotionType, completion: @escaping ( ([PromotionModel]) -> () )) {
        CoreDataManager.shared.fetchCoreData { result in
        switch result {
            case .success(let model):
                let userData = model.first
                if let id = userData?.id as? Int {
                    let urlString = "https://skillbox.cc/api/user/\(id)/promotions/\(type.rawValue)?page=1&per_page=20"
                    if let url = URL(string: urlString) {
                        DispatchQueue.global(qos: .userInitiated).async {
                            LoadManager.shared.loadData(of: PromotionDataModel.self, from: url, httpMethod: .get, passData: nil) { result in
                                switch result {
                                case .success(let model):
                                    DispatchQueue.main.async {
                                        completion(model.data)
                                    }
                                default:break
                                }
                            }
                        }
                    }
                }
            default: break
        }
    }
    }
    
    //показывает детальное описание акции
    
    static func getPromotionDescriptionWith(id:Int, _ completion: @escaping ( (String) -> () )) {
        CoreDataManager.shared.fetchCoreData { result in
        switch result {
            case .success(let model):
                let userData = model.first
                if let userID = userData?.id as? Int,
                   let url = URL(string: "https://skillbox.cc/api/user/\(userID)/promotion/\(id)") {
                    DispatchQueue.global(qos: .userInitiated).async {
                        LoadManager.shared.loadData(of: PromotionDetailModel.self, from: url, httpMethod: .get, passData: nil) { result in
                            switch result {
                            case .success(let model):
                                DispatchQueue.main.async {
                                    completion(model.data.description ?? "")
                                }
                            default:break
                            }
                        }
                    }
                }
        default:break
            }
        }
    }
     enum PromotionType: String {
        case food = "food"
        case taxi = "taxi"
    }
    
}
