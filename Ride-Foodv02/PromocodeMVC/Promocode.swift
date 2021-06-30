import Foundation


class Promocode {
    
    static func post(code:String,_ completion: @escaping ( (String) -> () )) {
        CoreDataManager.shared.fetchCoreData { result in
        switch result {
            case .success(let model):
                let userData = model.first
                if let id = userData?.id as? Int {
                    DispatchQueue.global(qos: .userInitiated).async {
                        if let url = URL(string: "https:skillbox.cc/api/user/\(id)/promo-codes/activate") {
                            var request = URLRequest(url: url)
                            request.httpMethod = "POST"
                            let params:[String:String] = ["code":code]
                            if let data = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) {
                                request.httpBody = data
                                let task = URLSession.shared.dataTask(with: request) { data, responce, error in
                                }
                                task.resume()
                            }
                        }
                    }
                }
        default: break
            }
        }
    
    }

}
