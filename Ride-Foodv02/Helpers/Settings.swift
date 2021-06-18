import Foundation

class Settings {
    
    static let shared = Settings()
    

    var language: String {
        set { UserDefaults.standard.setValue(newValue, forKey: kLanguage) }
        get { UserDefaults.standard.string(forKey: kLanguage) ?? "ru" }
    }
    var languageID: Int {
        set { UserDefaults.standard.setValue(newValue, forKey: kLanguageID) }
        get { UserDefaults.standard.integer(forKey: kLanguageID)  }
    }
    
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
    private var kLanguage = "rus"
    private var kLanguageID = "kLanguageID"
    
}
