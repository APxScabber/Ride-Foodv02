import Foundation
import CoreGraphics

struct SettingsConstant {
    
    static var settings:String { "settings".localized }
    static var language:String { "language".localized }
    static var languageChosen:String { "languageChosen".localized }
    static var personalInfo:String { "personalInfo".localized }
    static var pushNotification:String { "pushNotification".localized }
    static var promotionsNotification:String {"promotionsNotification".localized }
    static var promotionsAvailable:String { "promotionsAvailable".localized }
    static var automaticUpdateMessage:String { "automaticUpdateMessage".localized }
    static var locationUpdateMessage:String { "locationUpdateMessage".localized }
    
    static let name = "name".localized
    static let email = "E-mail"
    static let toolbarHeight: CGFloat = 152.0
   
}


extension String {
    
    var localized: String {
        let path = Bundle.main.path(forResource: Settings.shared.language, ofType: "lproj")
        
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    

    
}

