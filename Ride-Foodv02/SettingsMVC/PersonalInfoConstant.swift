import Foundation
import UIKit

struct PersonalInfoConstant {
    
    static let toolbarHeight: CGFloat = 152.0

    static let durationForAppearingToolbarView = 0.25
    
    static private var privacyFirst:String { Localizable.PersonalInfo.privacyFirst.localized }
    static private var privacySecond:String { Localizable.PersonalInfo.privacySecond.localized }
    static private var privacyThird:String { Localizable.PersonalInfo.privacyThird.localized }
    static private var privacyFourth:String { Localizable.PersonalInfo.privacyFourth.localized }

    static var privacyText:NSMutableAttributedString {
        let attrString = NSMutableAttributedString()
        let grayTextAttributes: [NSAttributedString.Key:Any] = [.foregroundColor: #colorLiteral(red: 0.4548282861, green: 0.4548282861, blue: 0.4548282861, alpha: 1)]
        let blueTextAttributes: [NSAttributedString.Key:Any] = [.foregroundColor: #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)]
        let str1 = NSAttributedString(string: privacyFirst, attributes: grayTextAttributes)
        let str2 = NSAttributedString(string: privacySecond, attributes: blueTextAttributes)
        let str3 = NSAttributedString(string: privacyThird, attributes: grayTextAttributes)
        let str4 = NSAttributedString(string: privacyFourth, attributes: blueTextAttributes)
        attrString.append(str1)
        attrString.append(str2)
        attrString.append(str3)
        attrString.append(str4)
        return attrString
    }
    
}
