//
//  UserDefaults+.swift
//  StarStarDiary
//
//  Created by juhee on 2019/12/19.
//  Copyright © 2019 mash-up. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    private static let defaults = UserDefaults.standard
    private static let fcmTokenKey = "fcmToken"
    private static let currentTokenKey = "currentToken"
    private static let refreshTokenKey = "refreshToken"
    private static let constellationKey = "constellation"
    private static let isFirstInKey = "isFirstIn"

    static var fcmToken: String? = defaults.string(forKey: fcmTokenKey) {
        willSet(newValue) {
            defaults.set(newValue, forKey: fcmTokenKey)
        }
    }
    
    static var currentToken: String? = defaults.string(forKey: currentTokenKey) {
        willSet(newValue) {
            defaults.set(newValue, forKey: currentTokenKey)
        }
    }

    static var refreshToken: String? = defaults.string(forKey: refreshTokenKey) {
        willSet(newValue) {
            defaults.set(newValue, forKey: refreshTokenKey)
        }
    }

    static var constellation: Constellation = Constellation(rawValue: defaults.string(forKey: constellationKey) ?? Constellation.aries.rawValue) ?? .aries {
        willSet(newValue) {
            defaults.set(newValue.rawValue, forKey: constellationKey)
        }
        didSet {
            NotificationCenter.default.post(name: .didChangeConstellation, object: nil)
        }
    }
    
    static var isFirstIn: Bool = defaults.value(forKey: isFirstInKey) as? Bool ?? true {
        willSet(newValue) {
            defaults.set(newValue, forKey: isFirstInKey)
        }
    }
    
}

extension Notification.Name {
    
    static let didChangeConstellation: Notification.Name = Notification.Name("didChangeConstellation")
}
