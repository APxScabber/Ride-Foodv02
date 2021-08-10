import Foundation


extension String {
    
    var localized: String {
        let path = Bundle.main.path(forResource: Settings.shared.language, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
}


protocol LocalizableDelegate {
    var rawValue: String { get }
    var localized: String { get }
}

extension LocalizableDelegate {

    var localized: String {
        let path = Bundle.main.path(forResource: Settings.shared.language, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(rawValue, tableName: nil, bundle: bundle!, value: "", comment: "")    }

}


enum Localizable {

    enum SettingsEnum: String, LocalizableDelegate {
        
        case settings, language,languageChosen,personalInfo,pushNotification,promotionsNotification,promotionsAvailable,automaticUpdateMessage,locationUpdateMessage,name,email
    }
}
