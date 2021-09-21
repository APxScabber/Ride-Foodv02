import Foundation

class CurrentShop {
    
    static let shared = CurrentShop()
    
    var shop: String {
        get { UserDefaults.standard.string(forKey: kShop) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: kShop)}
    }
    
    var total: Int {
        get { UserDefaults.standard.integer(forKey: kTotal) }
        set { UserDefaults.standard.set(newValue, forKey: kTotal) }
    }
    
    var id: Int {
        get { UserDefaults.standard.integer(forKey: kCurrentShopID) }
        set { UserDefaults.standard.set(newValue, forKey: kCurrentShopID) }
    }

    func reset() {
        id = 0
        total = 0
        shop = ""
    }
    
    private let kShop = "kShop"
    private let kTotal = "kTotal"
    private let kCurrentShopID = "kCurrentShopID"

}
