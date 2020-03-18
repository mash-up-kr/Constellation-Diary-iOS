//
//  Date+.swift
//  StarStarDiary
//
//  Created by juhee on 2019/12/31.
//  Copyright © 2019 mash-up. All rights reserved.
//

import Foundation


extension Date {
    
    private static let gregorianCalendar = Calendar(identifier: .gregorian)

    var isSunDay: Bool {
        let components = Date.gregorianCalendar.dateComponents([.weekday], from: self)
        return components.weekday == 1
    }
    
    var utc: String {
        return DateFormatter.utc.string(from: self)
    }
    
    var time: String {
        let localeFormatter = DateFormatter.defaultInstance
        localeFormatter.dateStyle = .none
        localeFormatter.timeStyle = .short
        return localeFormatter.string(from: self)
    }
    
    func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
         let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
         return addingTimeInterval(delta)
    }
    
    func isSameDate(with target: Date) -> Bool {
        let formatter = DateFormatter.defaultInstance
        formatter.dateStyle = .medium
        formatter.timeZone = .none
        let originDate = formatter.string(from: self)
        let targetDate = formatter.string(from: target)
        return originDate == targetDate
    }
    
}
