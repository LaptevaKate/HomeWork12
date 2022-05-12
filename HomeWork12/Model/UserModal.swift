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
    case owl
}

struct UserModel {
    let userName: String
    let mouseColor: String
    let speed: Int
    let obstruction: ObstructionType
}


