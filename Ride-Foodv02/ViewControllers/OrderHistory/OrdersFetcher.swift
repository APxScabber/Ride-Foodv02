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
                        if let from = $0["from"] as? String?,
                           let to = $0["to"] as? String,
                           let price = $0["price"] as? Int,
                           let type = $0["type"] as? String,
                           let status = $0["status"] as? String,
                           let date = $0["created_at"] as? Int,
                           let tariffDict = $0["tariff"] as? [String:Any]? {
                            let tariff = tariffDict?["name"] as? String
                            var order = Order(from: from, to: to, price: price, type: type == "taxi" ? "Такси" : "Еда", typeDetail: type == "taxi" ? "/ Услуги такси" : "/ Доставка еды", status: status, date: String(date))
                            order.tariff = tariff
                            if let taxiDict = $0["taxi"] as? [[String:Any]],
                               let firstTaxi = taxiDict.first,
                               let car = firstTaxi["car"] as? String,
                               let color = firstTaxi["color"] as? String,
                               let driver = firstTaxi["driver"] as? String,
                               let number = firstTaxi["number"] as? String,
                               let region = firstTaxi["region_number"] as? Int {
                                order.taxi = Order.Taxi(car: car, carColor: color, driver: driver, number: number, region: region)
                            }
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
