import Foundation

class Settings {
    
    static let shared = Settings()
    
    var shouldUpdateOnCellular: Bool {
        set { UserDefaults.standard.setValue(newValue, forKey: kShouldUpdateOnCellular) }
        get { UserDefaults.standard.bool(forKey: kShouldUpdateOnCellular) }
    }
    
    var shouldNotifyPromotions: Bool {
        set { UserDefaults.standard.setValue(newValue, forKey: kShouldNotifyPromotions) }
        get { UserDefaults.standard.bool(forKey: kShouldNotifyPromotions) }
    }
    
    var shouldSendPush: Bool {
        set { UserDefaults.standard.setValue(newValue, forKey: kShouldSendPush) }
        get { UserDefaults.standard.bool(forKey: kShouldSendPush) }
    }
    
    private var kShouldUpdateOnCellular = "kShouldUpdateOnCellular"
    private var kShouldNotifyPromotions = "kShouldNotifyPromotions"
    private var kShouldSendPush = "kShouldSendPush"
    private var kLanguage = "kLanguage" 
    
}
