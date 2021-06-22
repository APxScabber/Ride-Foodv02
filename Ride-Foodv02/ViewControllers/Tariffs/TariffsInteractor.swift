//
//  TariffsInteractor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 15.06.2021.
//

import Foundation
import UIKit

class TariffsInteractor {
    
    var userID: String?
    
    init() {
    }
    
    //Загружаем данные о Тарифах
    func loadTariffs(userID: String, completion: @escaping ([TariffsModel]?) -> Void) {

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
    
    //Получаем картинку машины с сервера
    func getImage(from server: String) -> UIImage? {
        
        var image: UIImage?
        guard let url = URL(string: server) else { return nil }
        
        if let data = NSData(contentsOf: url) {
            image = UIImage(data: data as Data)
        }
        
        return image
    }
}
