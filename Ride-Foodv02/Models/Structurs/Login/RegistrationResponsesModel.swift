//
//  ConfirmModel.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.06.2021.
//

import Foundation

//Модель данных для кода подтверждения
struct RegistrationResponsesModel: Decodable {
    var data: ConfirmationCodeModel
}

struct ConfirmationCodeModel: Decodable {
    var code: Int
}
