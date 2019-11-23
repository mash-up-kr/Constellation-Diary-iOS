//
//  DateFormatter+.swift
//  StarStarDiary
//
//  Created by juhee on 2019/11/24.
//  Copyright © 2019 mash-up. All rights reserved.
//

import Foundation


extension DateFormatter {
    
    /// 공통적으로 사용할 수 있는 timeZone과 locale이 설정된 instance 입니다.
    static let defualtInstance: DateFormatter = {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()
    
}
