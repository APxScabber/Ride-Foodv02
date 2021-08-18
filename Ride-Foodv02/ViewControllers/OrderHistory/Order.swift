import Foundation

struct Order: Decodable {
    
    let from: String?
    let to: String
    let price: Int
    let type: String
    let typeDetail: String
    let status: String
    var tariff: String? = nil
    let date: String
    
    var taxi: Taxi? = nil
    
    struct Taxi: Decodable {
        let car:String
        let carColor: String
        let driver: String
        let number: String
        let region: Int
    }
    
    
    
    
}
