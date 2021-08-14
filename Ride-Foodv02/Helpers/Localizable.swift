import Foundation

enum Localizable {

    enum Settings: String, LocalizableDelegate {
        
        case settings, language,languageChosen,personalInfo,pushNotification,promotionsNotification,promotionsAvailable,automaticUpdateMessage,locationUpdateMessage,name
        
    }
    
    enum Menu:String,LocalizableDelegate {
        
        case menu,support,settings,paymentWays,tariffs,promocode,promotions,aboutThisApp
        
    }
    
    enum Support: String,LocalizableDelegate {
        case cancel,capture,library,done,messageSent,next,problemDesc,addImageDesc,photoLimitDesc,responceDesc,send
            
    }
    
    enum PersonalInfo:String,LocalizableDelegate {
        
        case name,nameQuestion,emailQuestion,personalInfo,confirm,privacyFirst,privacySecond,privacyThird,privacyFourth

    }
    
    enum Promotion:String,LocalizableDelegate {
        
        case food,taxi,promotion,goShopping,errorDescription,more
        
    }
    
    enum Promocode:String,LocalizableDelegate {
        
        case promocode,enterPromocode,historyUsage,confirm,promocodeActivated,done,active,inactivate,promocodeDescription
            
    }
    
    enum Food:String,LocalizableDelegate {
        
        case map,enterAdress,confirm
           
    }
    
    enum Taxi:String,LocalizableDelegate {
        case fromAddressQuestion,toAddressQuestion,map,next,confirm,fromAddressDetail,toAddressDetail
    }
    
    enum UserProfile: String, LocalizableDelegate {
        case profile, enterPhoneNumber, myAddresses, paymentHistory, ordersHistory, paymentMethod, logOut, logoutQuestion
    }
    
    enum Addresses: String, LocalizableDelegate {
        case myAddresses, addAddress, newAddress, addressName, address, map, driverCommentary, forDelivery, appartment, intercom, entrance, floor, courierCommentary, save, update, setAsDistination, delete, deleteAddressQuestion, cancel
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

extension String {

    var localized: String {
        let path = Bundle.main.path(forResource: Settings.shared.language, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")    }

}
