//
//  UrlList.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 09.06.2021.
//

import Foundation

//Список URL
private let baseURL = "https://skillbox.cc/api"
public let registrationURL = baseURL + "/auth/registration"
public let confirlURL = baseURL + "/auth/confirm"
#warning("Обязательно поправить на принятие всех трех тарифов или можно сделать для каждого VC свой?")
public let tariffsURL = baseURL + "/user/@#^/tariff/2"
