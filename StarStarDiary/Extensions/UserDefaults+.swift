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
    private static let currentTokenKey = "currentToken"
    private static let refreshTokenKey = "refreshToken"

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

}
