import Foundation

class ShopDetail {

    let id: Int
    let name: String
    let schedule: String
    let description: String
    let address:String
    let iconURL:String
    let categories: [Category]
    
    init(id:Int,name:String,schedule:String,description:String,address:String,iconURL:String,categories:[Category]) {
        self.id = id
        self.name = name
        self.schedule = schedule
        self.description = description
        self.address = address
        self.iconURL = iconURL
        self.categories = categories
    }
    
    struct Category {
        let id:Int
        let name:String
        let iconURL:String
    }
    
}
