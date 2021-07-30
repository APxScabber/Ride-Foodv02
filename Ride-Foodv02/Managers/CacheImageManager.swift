//
//  CacheImageManager.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 24.07.2021.
//
import Foundation
import UIKit

class CacheImageManager {
    
    static let shared = CacheImageManager()
    
    private let cache = NSCache<NSURL, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    private init() {
    }
    
    //MARK: - Methods
    
    //Загружаем с сервера или из кэша картинку автомобиля
    func cacheImage(from server: String, completion: @escaping (UIImage?) -> Void) {
        
        CacheImageManager.shared.utilityQueue.async {
            guard let stringServer = NSURL(string: server) else { return }
            
            if let cachedImage = CacheImageManager.shared.cache.object(forKey: stringServer) {
                completion(cachedImage)
            } else {
                
                guard let url = URL(string: server) else { return }
                
                guard let data = try? Data(contentsOf: url) else { return }
                guard let image = UIImage(data: data) else { return }
                
                CacheImageManager.shared.cache.setObject(image, forKey: stringServer)
                completion(image)
            }
        }
    }
    
    //Загружаем с сервера или из кэша картинки и описания дополнительных опций в тарифе
    func getAdvantagesDatas(model: ([AdvantagesModel]),
                            completion: @escaping (_ icons: [UIImage], _ titles: [String]) -> Void) {
        
            var advantagesIconsArray = [UIImage]()
            var advantagesTitlesArray = [String]()
            
            for modelData in model {
                
                guard let stringServer = NSURL(string: modelData.icon) else { return }
                
                if let cachedImage = CacheImageManager.shared.cache.object(forKey: stringServer) {
                    advantagesIconsArray.append(cachedImage)
                    advantagesTitlesArray.append(modelData.name)
                } else {
                    
                    guard let url = URL(string: modelData.icon) else { return }
                    
                    guard let data = try? Data(contentsOf: url) else { return }
                    guard let image = UIImage(data: data) else { return }
                    
                    CacheImageManager.shared.cache.setObject(image, forKey: stringServer)
                    advantagesIconsArray.append(image)
                    advantagesTitlesArray.append(modelData.name)
                }
            }
            
            completion(advantagesIconsArray, advantagesTitlesArray)
    }
}
