import Foundation


class CurrentPayment {
    
    static let shared = CurrentPayment()
    
    var id: Int {
        get { UserDefaults.standard.integer(forKey: kCurrentPaymentID) }
        set { UserDefaults.standard.set(newValue, forKey: kCurrentPaymentID) }
    }
    
    var payment: String {
        get { UserDefaults.standard.string(forKey: kCurrentPayment) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: kCurrentPayment) }
    }
    
    private let kCurrentPaymentID = "kCurrentPaymentID"
    private let kCurrentPayment = "kCurrentPayment"
}
