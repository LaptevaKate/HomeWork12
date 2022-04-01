//
//  UserModal.swift
//  HomeWork12
//
//  Created by Екатерина Лаптева on 31.03.22.
//

import Foundation

enum ObstructionType: String {
    case cat
    case dog
    case snake
    case owl
}

class UserModel {
    
    
    let userName: String
    let mouseColor: String
    let speed: Int
    let obstruction: ObstructionType
    
    init(userName: String, mouseColor: String, speed: Int, obstruction: ObstructionType) {
        self.userName = userName
        self.mouseColor = mouseColor
        self.speed = speed
        self.obstruction = obstruction
    }
    
}
