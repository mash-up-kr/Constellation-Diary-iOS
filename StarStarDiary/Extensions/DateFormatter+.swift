//
//  DateFormatter+.swift
//  StarStarDiary
//
//  Created by juhee on 2019/11/24.
//  Copyright © 2019 mash-up. All rights reserved.
//

import Foundation


extension DateFormatter {
    
    static let defualtInstance: DateFormatter = {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()
    
}
