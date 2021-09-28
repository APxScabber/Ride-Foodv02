import Foundation

class ConfirmationCode {
    
    static let shared = ConfirmationCode()
    
    var current:String {
        get { UserDefaults.standard.string(forKey: kConfirmationCode) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: kConfirmationCode) }
    }
    
    
    private let kConfirmationCode = "kConfirmationCode"
    
}
