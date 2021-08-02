import Foundation
import UIKit

struct PersonalInfoConstant {
    
    static var name:String { "name".localized }
    static var nameQuestion:String { "nameQuestion".localized }
    static var emailQuestion:String { "emailQuestion".localized }
    static var personalInfo:String { "personalInfo".localized }
    static var confirm:String { "confirm".localized }

    static let durationForDisappearingToolbarView = 0.25
    
    static private var privacyFirst:String { "privacyFirst".localized }
    static private var privacySecond:String { "privacySecond".localized }
    static private var privacyThird:String { "privacyThird".localized }
    static private var privacyFourth:String { "privacyFourth".localized }

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
