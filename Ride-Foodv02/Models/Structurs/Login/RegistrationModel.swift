//
//  LoginModel.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.06.2021.
//

import Foundation

#warning("Они не нужны? вместо них enums")
//Модель данных для отправки номера телефона/регистрации
struct RegistrationModel: Decodable {
    var phone: [String : String]
}
