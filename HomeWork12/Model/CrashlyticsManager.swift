//
//  CrashlyticsSender.swift
//  HomeWork12
//
//  Created by Екатерина Лаптева on 16.05.22.
//

import Foundation
import Firebase

enum FailureType: String {
    case unwrap = "Unable To Unwrap Optional"
    case emptyRecord = "Record is Empty"
}

class CrashlyticsManager {
    
    static func makeError(reason: FailureType, code: Int = -1001, domain: String = NSCocoaErrorDomain) {
        let userInfo = [
            NSLocalizedDescriptionKey: NSLocalizedString(reason.rawValue, comment: ""),
        ]
        let error = NSError(domain: domain, code: code, userInfo: userInfo)
        Crashlytics.crashlytics().record(error: error)
    }
}
