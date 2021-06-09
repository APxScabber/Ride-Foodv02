//
//  ConfirmModel.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 09.06.2021.
//

import Foundation

#warning("Они не нужны? вместо них enums")
//Модель данных для отправки кода подтверждения
struct ConfirmModel: Decodable {
    var phone: [String : String]
    var code: [String : String]
}
