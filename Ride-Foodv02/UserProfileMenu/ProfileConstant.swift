import Foundation
import CoreGraphics

struct ProfileConstant {
    
    static var userProfile: String { "userProfile".localized }
    static var enterPhone: String { "enterPhone".localized }
    static var myAddresses: String { "myAddresses".localized }
    static var logout: String { "logout".localized }

    static var data: [String] { ["paymentHistory".localized,
                                 "orderHistory".localized,
                                 "paymentWays".localized]}
    
    static var addPhone: String { "addPhone".localized }
    static var changePhone: String { "changePhone".localized }
    static var confirm: String { "confirm".localized }
    static var confirmationCode: String { "confirmationCode".localized }
    static var main: String { "main".localized }
    
    static let phoneChooserViewHeight: CGFloat = 165.0
    static let enterPhoneViewHeight: CGFloat = 152.0
    
    
    static let durationForAppearingEnterPhoneView = 0.25
    static let durationForAppearingPhoneChooserView = 0.25

}
