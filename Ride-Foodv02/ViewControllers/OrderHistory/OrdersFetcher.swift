import Foundation


class OrdersFetcher {
    
    static func fetch(_ completion: @escaping ( ([Order],[Order]) -> () )) {
        
        var done = [Order]()
        var canceled = [Order]()
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = URL(string: "https:skillbox.cc/api/user/2/history/order/all/") else { return }
            
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, responce, error in
                
                guard let data = data else { return }
                guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else { return }
                
                if let jsonDict = json as? [String:Any],
                   let jsonData = jsonDict["data"] as? [[String:Any?]] {
                    jsonData.forEach {
                        if let from = $0["from"] as? String,
                           let to = $0["to"] as? String,
                           let price = $0["price"] as? Int,
                           let type = $0["type"] as? String,
                           let status = $0["status"] as? String,
                           let date = $0["created_at"] as? Int {
                            let order = Order(from: from, to: to, price: price, type: type, status: status, date: String(date))
                            if status == "done" {
                                done.append(order)
                            }
                            if status == "canceled" {
                                canceled.append(order)
                            }
                        }
                        
                    }
                    DispatchQueue.main.async {
                        completion(done,canceled)
                    }
                }
            }
            task.resume()
        }
    }
    
    
}
