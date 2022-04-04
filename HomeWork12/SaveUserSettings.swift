//
//  SaveUserSettings.swift
//  HomeWork12
//
//  Created by Екатерина Лаптева on 31.03.22.
//

import Foundation
import UIKit

enum SaveKeys: String {
    case userName, mouseColor, obstruction, speed, userImage
}

class SaveUserSettings {
    private let defaults = UserDefaults.standard
    
    public static var shared = SaveUserSettings()
    
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
            guard let value = defaults.string(forKey: SaveKeys.speed.rawValue) else { return "" }
            return value
        }
        set {
            defaults.setValue(newValue, forKey: SaveKeys.speed.rawValue)
        }
    }
    
    var mouseColor: String {
        get {
            guard let value = defaults.string(forKey: SaveKeys.mouseColor.rawValue) else { return "" }
            return value
        }
        set {
            defaults.setValue(newValue, forKey: SaveKeys.mouseColor.rawValue)
        }
    }
    
    var obstruction: String {
        get {
            guard let value = defaults.string(forKey: SaveKeys.obstruction.rawValue) else { return "" }
            return value
        }
        set {
            defaults.setValue(newValue, forKey: SaveKeys.obstruction.rawValue)
        }
    }
    
    var userImage: UIImage? {
        get {
            guard let value = defaults.data(forKey: SaveKeys.userImage.rawValue) else { return nil }
            let decoded = try! PropertyListDecoder().decode(Data.self, from: value)
            return UIImage(data: decoded)
        }
        set {
            guard let image = newValue, let value = image.jpegData(compressionQuality: 0.5) else { return }
            let encoded = try! PropertyListEncoder().encode(value)
            UserDefaults.standard.set(encoded, forKey: SaveKeys.userImage.rawValue)
        }
    }
}




