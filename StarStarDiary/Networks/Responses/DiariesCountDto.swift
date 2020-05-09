//
//  DiariesCountDto.swift
//  StarStarDiary
//
//  Created by suhyun on 2020/03/17.
//  Copyright © 2020 mash-up. All rights reserved.
//

import Foundation

struct YearlyDiaryResponse: Decodable {
    let timeZone: String?
    let diaries: [YearlyDiary]?
}

struct MonthlyDiary: Decodable {
    let name: String
    let count: Int
}

struct YearlyDiary: Decodable {
    var year: Int = 0
    var countsInMonth: [MonthlyDiary] = []
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case year
        case january
        case february
        case march
        case april
        case may
        case june
        case july
        case august
        case september
        case october
        case november
        case december
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
//        year = try values.decode(Int.self, forKey: .year)
        for (index, coadingKey) in CodingKeys.allCases.enumerated() {
            if coadingKey == .year {
                year = try values.decode(Int.self, forKey: .year)
            } else {
                let diaryCount = try values.decode(Int.self, forKey: coadingKey)
                countsInMonth.append(MonthlyDiary(name: "\(index)월", count: diaryCount))
            }
        }
    }
}
