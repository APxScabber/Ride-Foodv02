import Foundation

class CurrentAddress {
    
    static let shared = CurrentAddress()
    
    var place: String {
        get { UserDefaults.standard.string(forKey: kPlace) ?? ""}
        set { UserDefaults.standard.setValue(newValue, forKey: kPlace)}
    }
    
    var address:String {
        get { UserDefaults.standard.string(forKey: kAddress) ?? ""}
        set { UserDefaults.standard.setValue(newValue, forKey: kAddress)}
    }
    
    
    private let kPlace = "kPlace"
    private let kAddress = "kAddress"
}
