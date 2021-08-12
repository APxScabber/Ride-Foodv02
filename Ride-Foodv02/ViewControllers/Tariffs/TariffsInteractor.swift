//
//  TariffsInteractor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 15.06.2021.
//
import Foundation
import UIKit

class TariffsInteractor {
    
    //Загружаем данные о Тарифах
    func loadTariffs(completion: @escaping ([TariffsModel]?) -> Void) {
        
        guard let userID = GetUserIDManager.shared.userID else { return }
        
        let urlString = separategURL(url: tariffsURL, userID: userID)
        guard let url = URL(string: urlString) else { return }
        
        LoadManager.shared.loadData(of: TariffsDataModel.self,
                                    from: url, httpMethod: .get, passData: nil) { result in
            switch result {
            case .success(let dataModel):
                
                completion(dataModel.data)
            case .failure(let error):
                
                completion(nil)
                print("Tariffs error: \(error.localizedDescription)")
            }
        }
    }
    
    //Разбиваем текст по компонентам использую ключ в виде @#^
    func separategURL(url: String, userID: String) -> String {
        
        let textArray = url.components(separatedBy: "@#^")
        let finalUrl = textArray[0] + userID + textArray[1]
        
        return finalUrl
    }
}
