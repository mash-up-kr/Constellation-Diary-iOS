//
//  NotificationName.swift
//  StarStarDiary
//
//  Created by juhee on 2020/05/09.
//  Copyright © 2020 mash-up. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    static let didChangeConstellation: Notification.Name = Notification.Name("didChangeConstellation")
    static let didDeleteDiaryNotification: Notification.Name = Notification.Name("didDeleteDiary")
    static let didWriteDiaryNotification: Notification.Name = Notification.Name("didWriteDiary")
    
}

struct NotificationInfoKey {
    
    static let deletedDiaryIDKey: String = "deletedDiaryIDKey"
    static let horoscopeIDKey: String = "deletedDiaryIDKey"
    
}
