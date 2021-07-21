//
//  CardsUserDefaultsModel.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 10.07.2021.
//

import Foundation

class CardsUserDefaultsModel: NSObject, NSCoding {
    
    var id: Int
    var number: String
    var expiry_date: String
    var status: String


    init(id: Int, number: String, expiry_date: String, status: String) {
        self.id = id
        self.number = number
        self.expiry_date = expiry_date
        self.status = status
    }

    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: "id")
        let number = aDecoder.decodeObject(forKey: "number") as! String
        let expiry_date = aDecoder.decodeObject(forKey: "expiry_date") as! String
        let status = aDecoder.decodeObject(forKey: "status") as! String
        self.init(id: id, number: number, expiry_date: expiry_date, status: status)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(number, forKey: "number")
        aCoder.encode(expiry_date, forKey: "expiry_date")
        aCoder.encode(status, forKey: "status")
    }
}
