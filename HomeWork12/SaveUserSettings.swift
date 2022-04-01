//
//  SaveUserSettings.swift
//  HomeWork12
//
//  Created by Екатерина Лаптева on 31.03.22.
//

import Foundation

enum SaveKeys: String {
    case userName, mouseColor, obstruction, speed
}

class SaveUserSettings {
    private let defaults = UserDefaults.standard
    
    class var shared: SaveUserSettings {
        struct Static {
            static let instance = SaveUserSettings()
        }
        return Static.instance
    }
    
    var userName: String? {
        get {
            return defaults.string(forKey: SaveKeys.userName.rawValue)
        }
        set {
            defaults.setValue(newValue, forKey: SaveKeys.userName.rawValue)
        }
    }
    
    var speed: String {
        get {
            guard let value = defaults.string(forKey: SaveKeys.speed.rawValue) else { return ""}
            return value
        }
        set {
            defaults.setValue(newValue, forKey: SaveKeys.speed.rawValue)
        }
    }
    
    var mouseColor: String {
        get {
            guard let value = defaults.string(forKey: SaveKeys.mouseColor.rawValue) else { return ""}
            return value
        }
        set {
            defaults.setValue(newValue, forKey: SaveKeys.mouseColor.rawValue)
        }
    }
    
    var obstruction: String {
        get {
            guard let value = defaults.string(forKey: SaveKeys.obstruction.rawValue) else { return ""}
            return value
        }
        set {
            defaults.setValue(newValue, forKey: SaveKeys.obstruction.rawValue)
        }
    }
}




