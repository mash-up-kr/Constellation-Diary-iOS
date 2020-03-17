//
//  DiariesCountDto.swift
//  StarStarDiary
//
//  Created by suhyun on 2020/03/17.
//  Copyright © 2020 mash-up. All rights reserved.
//

import Foundation

struct DiariesCountDto: Decodable {
    let timeZone: String?
    let diaries: [DiariesCountOfMonthDto]?
}

struct DiariesCountOfMonthDto: Decodable {
    let year: Int?
    let countsInMonth: [Int]?
    
    private var january: Int = 0
    private var february: Int = 0
    private var march: Int = 0
    private var april: Int = 0
    private var may: Int = 0
    private var june: Int = 0
    private var july: Int = 0
    private var august: Int = 0
    private var september: Int = 0
    private var october: Int = 0
    private var november: Int = 0
    private var december: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case year
        case countsInMonth
        
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
        
        year = try values.decode(Int.self, forKey: .year)

        january = try values.decode(Int.self, forKey: .january)
        february = try values.decode(Int.self, forKey: .february)
        march = try values.decode(Int.self, forKey: .march)
        april = try values.decode(Int.self, forKey: .april)
        may = try values.decode(Int.self, forKey: .may)
        june = try values.decode(Int.self, forKey: .june)
        july = try values.decode(Int.self, forKey: .july)
        august = try values.decode(Int.self, forKey: .august)
        september = try values.decode(Int.self, forKey: .september)
        october = try values.decode(Int.self, forKey: .october)
        november = try values.decode(Int.self, forKey: .november)
        december = try values.decode(Int.self, forKey: .december)
        
        countsInMonth = [january, february, march, april, may, june, july, august, september, october, november, december]
    }
}
