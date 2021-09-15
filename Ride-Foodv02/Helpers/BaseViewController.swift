//
//  BaseViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 16.08.2021.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Properties
    
    var userID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        getUserID()
    }
    
    // MARK: - Methods
    
    //Получаем ID пользователя для дальнейшего использования в запросах к серверу
    func getUserID() {
        
        CoreDataManager.shared.fetchCoreData { [weak self] result in
            
            switch result {
            case .success(let model):
                let userData = model.first
                self?.userID = String(describing: userData!.id!)
            case .failure(let error):
                print(error)
            case .none:
                return
            }
        }
    }
    
    //Создаем атребуты для инфо поля, для создания гиперссылки на пользовательское соглашение
    func createTextAttribute(inputText: String, type: [NSAttributedString.Key : Any],
                                locRus: Int, lenRus: Int, locEng: Int, lenEng: Int) -> NSMutableAttributedString {
        
        let licenseText = inputText
        let attributedString = NSMutableAttributedString(string: licenseText)
        
        switch UserDefaultsManager().getLanguage() {
        case "rus":
            
            attributedString.addAttributes(type, range: NSRange(location: locRus, length: lenRus))
        case "eng":
            
            attributedString.addAttributes(type, range: NSRange(location: locRus, length: lenRus))
        default:
            attributedString.addAttributes(type, range: NSRange(location: 0, length: 0))
        }
        
        return attributedString
    }
}
