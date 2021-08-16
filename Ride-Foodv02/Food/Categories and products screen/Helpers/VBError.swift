//
//  VBError.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 17.08.2021.
//

enum VBError: String, Error {
    case invalidUsername = "invalid request. Please try again"
    case unableToComplete = "Unable to complete your request. Please check your connection"
    case invalidResponse = "Invalid response from the server. Please try again"
    case invalidData = "Data received from the server was invalid, please try again"
}
