import Foundation


class Promocode {
    
    let title:String
    let description: String
    var status: PromocodeStatus
    var statusDescription:String
    
    init(title:String,description:String,status:PromocodeStatus,statusDescription:String) {
        self.title = title
        self.description = description
        self.status = status
        self.statusDescription = statusDescription
    }
    
    enum PromocodeStatus {
        case active
        case activated
        case expired
    }
}
