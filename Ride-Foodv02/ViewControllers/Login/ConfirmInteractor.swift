//
//  ConfirmInteractor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 09.06.2021.
//

import Foundation
import UIKit

class ConfirmInteracor {
    
    // MARK: - Methods
    
    //Отправляем код подтверждения и получаем данные пользователя
    func passConfirmationCode(phoneNumber: String, code: String, compitition: @escaping (Error?) -> Void ) {

        let url =  URL(string: confirlURL)
        
        let formatedPhoneNumber = phoneNumber.applyPatternOnNumbers(pattern: LoginConstantText.phoneFormatEasy.rawValue,
                                                                    replacmentCharacter: "#")
        
        let passData = ["phone" : formatedPhoneNumber, "code" : code]
        
        LoadManager.shared.loadData(of: ConfirmResponsesModel.self, from: url!, httpMethod: .post,
                                    passData: passData) { result in
            
            switch result {
            case .success(let model):
                let confirmModel = model.data
                
                CoreDataManager().saveCoreData(model: confirmModel)
                
                DispatchQueue.main.async {
                    compitition(nil)
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    compitition(error)
                }
            }
        }
    }
    
    //Определяем начальную точку и длинну выделения цветом таймера в зависимости от выбранного языка
    func selectLanguage(_ textCount: Int) -> (start: Int, lenght: Int) {
        
        var startColorLocation = 0
        var colorLenght = 0

        switch UserDefaultsManager().getLanguage() {
        
        case "rus":
            startColorLocation = textCount - 10
            colorLenght = 10
            
            if textCount == 85 {
                startColorLocation = textCount - 9
                colorLenght = 9
            }
        case "eng":
            startColorLocation = textCount - 10
            colorLenght = 10
            
            if textCount == 75 {
                startColorLocation = textCount - 9
                colorLenght = 8
            }
        default:
            return (0, 0)
        }
        return (startColorLocation, colorLenght)
    }
    
    //Разбиваем текст по компонентам использую ключ в виде @#^
    func separategText(phoneNumber: String, seconds: Int) -> String {
        
        let text = ConfirmText.info.text()
        let textArray = text.components(separatedBy: "@#^")
        let licenseText = textArray[0] + phoneNumber + textArray[1] + String(seconds) + textArray[2]
        
        return licenseText
    }
}
