//
//  LocalTime.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/02/09.
//  Copyright © 2020 mash-up. All rights reserved.
//

import Foundation

struct LocalTime: Encodable {
    let hour: Int
    let minute: Int
    let second: Int
    
    init(time: String) {
        let splitTimes = time.split(separator: ":").map({ Int(String($0)) ?? 0 })
        self.hour = splitTimes[0]
        self.minute = splitTimes[1]
        self.second = splitTimes[2]
    }
    
    func toString() -> String {
        return "\(hour):\(minute):\(second)"
    }
    
    var date: Date {
        guard let date = Calendar.current.date(bySettingHour: hour, minute: minute, second: second, of: Date()) else {
            preconditionFailure()
        }
        return date
    }

}
