//
//  ResultGame.swift
//  HomeWork12
//
//  Created by Екатерина Лаптева on 18.04.22.
//

import Foundation

struct RecordGame: Codable, Comparable {
    static func < (lhs: RecordGame, rhs: RecordGame) -> Bool {
        lhs.userScore < rhs.userScore
    }
    var userName: String
    var userScore: Int
    var date: Date
}
