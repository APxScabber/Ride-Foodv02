//
//  ConfirmModel.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.06.2021.
//

import Foundation

//Модель данных для получения кода подтверждения
struct RegistrationResponsesModel: Decodable {
    var data: RegistrationModel
}

struct RegistrationModel: Decodable {
    var code: Int
}
