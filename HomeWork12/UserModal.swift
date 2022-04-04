//
//  UserModal.swift
//  HomeWork12
//
//  Created by Екатерина Лаптева on 31.03.22.
//

import Foundation
import UIKit

enum ObstructionType: String {
    case cat
    case dog
    case snake
    case owl
}

struct UserModel {
    
    
    let userName: String
    let mouseColor: String
    let speed: Int
    let obstruction: ObstructionType
}

extension UIColor {
    static func fromString(_ colorString: String) -> UIColor{
        switch colorString {
        case "Green":
            return UIColor.green
        case "Red":
            return UIColor.red
        case "Yellow":
            return UIColor.yellow
        case "Blue":
            return UIColor.blue
        case "Black":
            return UIColor.black
        default:
            return UIColor.clear
        }
    }
}
