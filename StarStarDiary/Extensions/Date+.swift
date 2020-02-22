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
    
}
