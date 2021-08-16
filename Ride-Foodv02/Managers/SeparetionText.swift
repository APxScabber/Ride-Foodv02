//
//  SeparetionURL.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 16.08.2021.
//

import Foundation

class SeparetionText {
    
    //Разбиваем текст по компонентам использую ключ в виде @#^
    func separation(input text: String, insert: String) -> String {
        
        let textArray = text.components(separatedBy: "@#^")
        let finalText = textArray[0] + insert + textArray[1]
        
        return finalText
    }
}
