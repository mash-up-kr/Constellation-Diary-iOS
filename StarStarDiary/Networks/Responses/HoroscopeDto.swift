//
//  ResHoroscopeDto.swift
//  MashUpAPITest
//
//  Created by 이동영 on 2020/02/06.
//  Copyright © 2020 이동영. All rights reserved.
//

import Foundation

struct HoroscopeDto: Decodable {
    let id: Int
    let constellation: String
    let content: String
    let date: String
    let items: [FortuneItem]
    
    enum CodingKeys: String, CodingKey {
        case id
        case constellation
        case content
        case date
        case exercise
        case numeral
        case stylist
        case word
    }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        constellation = try values.decode(String.self, forKey: .constellation)
        id = try values.decode(Int.self, forKey: .id)
        date = try values.decode(String.self, forKey: .date)
        content = try values.decode(String.self, forKey: .content)
        
        var items: [FortuneItem] = []
        let exercise = try values.decode(String.self, forKey: .exercise)
        let numeral = try values.decode(String.self, forKey: .numeral)
        let stylist = try values.decode(String.self, forKey: .stylist)
        let word = try values.decode(String.self, forKey: .word)
        items.append(FortuneItem(type: .exercise, text: exercise))
        items.append(FortuneItem(type: .number, text: numeral))
        items.append(FortuneItem(type: .clothes, text: stylist))
        items.append(FortuneItem(type: .word, text: word))
        self.items = items
    }
}
