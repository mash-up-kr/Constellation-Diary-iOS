//
//  PushManager.swift
//  StarStarDiary
//
//  Created by suhyun on 2020/03/25.
//  Copyright © 2020 mash-up. All rights reserved.
//

import Foundation
import Firebase
import FirebaseMessaging
import UserNotifications

enum PushType: CaseIterable {
    case question
    case horoscope
    case none
    
    static func toType(rawValue: String) -> Self {
        for type in PushType.allCases where type.key == rawValue {
            return type
        }
        
        return .none
    }
    
    var key: String {
        switch self {
        case .question:
            return "QUESTION"
        case .horoscope:
            return "HOROSCOPE"
        case .none:
             return ""
        }
    }
}

final class PushManager {
    
    static let share = PushManager()
    
    func registerPush() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        FirebaseApp.configure()
        Messaging.messaging().delegate = appDelegate
        UNUserNotificationCenter.current().delegate = appDelegate
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions,completionHandler: {_, _ in })
        UIApplication.shared.registerForRemoteNotifications()
    }
}
