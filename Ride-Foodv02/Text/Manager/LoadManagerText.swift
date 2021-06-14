//
//  LoadManagerText.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 13.06.2021.
//

import Foundation

//Перечень HTTP запросов на сервер
enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

//Перечень ошибок при работе с сервером
enum DataError: Error {
    case invalideResponse
    case invalideData
    case decodingError
    case serverError
}
