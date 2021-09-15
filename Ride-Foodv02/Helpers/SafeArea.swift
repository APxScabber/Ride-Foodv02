import Foundation

//нужен для кастомных переходов, safeArea равна 0 для всех устройств что неправильно, данные запоминает при первоначальном входе

class SafeArea {

    static let shared = SafeArea()
    

    var top: Float {
        set { UserDefaults.standard.setValue(newValue, forKey: kTop) }
        get { UserDefaults.standard.float(forKey: kTop) }
    }
    
    var bottom: Float {
        set { UserDefaults.standard.setValue(newValue, forKey: kBottom) }
        get { UserDefaults.standard.float(forKey: kBottom) }
    }
    
    
    private let kTop = "kTop"
    private let kBottom = "kTop"

}
