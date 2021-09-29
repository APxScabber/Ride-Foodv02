import Foundation

protocol PromocodeActivatorDelegate: AnyObject {
    func promocodeActivated(_ description:String)
    func promocodeFailed(_ error:String)
}

class PromocodeActivator {
    
    static weak var delegate: PromocodeActivatorDelegate?
    
    static func post(code:String) {
        delegate?.promocodeActivated("desc")

//        CoreDataManager.shared.fetchCoreData { result in
//        switch result {
//            case .success(let model):
//                let userData = model.first
//                if let id = userData?.id as? Int {
//                    DispatchQueue.global(qos: .userInitiated).async {
//                        if let url = URL(string: "https:skillbox.cc/api/user/\(id)/promo-codes/activate") {
//                            var request = URLRequest(url: url)
//                            let params:[String:Any] = ["code":code]
//                            if let data = try? JSONSerialization.data(withJSONObject: params) {
//                                request.httpMethod = "POST"
//                                request.httpBody = data
//                                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//                                let task = URLSession.shared.dataTask(with: request) { data, responce, error in
//                                    guard let data = data else { return }
//                                    if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
//                                       let dict = json as? [String:Any]{
//                                        if let data = dict["data"] as? [String:Any],
//                                           let desc = data["description"] as? String {
//                                            DispatchQueue.main.async {
//                                                delegate?.promocodeActivated(desc)
//                                            }
//                                        }
//                                        if let error = dict["error"] as? String {
//                                            DispatchQueue.main.async {
//                                                delegate?.promocodeFailed(error)
//                                            }
//                                        }
//                                    }
//                                }
//                                task.resume()
//                            }
//                        }
//                    }
//                }
//        default: break
//            }
//        }
    
    }

}
