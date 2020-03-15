//
//  ResDiariesDto.swift
//  MashUpAPITest
//
//  Created by 이동영 on 2020/02/06.
//  Copyright © 2020 이동영. All rights reserved.
//

import Foundation

struct SimpleDiaryDto: Decodable {
    let date: Date
    let id: Int?
    let title: String?
    
    enum CodingKeys: String, CodingKey {
        case date
        case id
        case title
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let dateString = try values.decode(String.self, forKey: .date)
        let dateformatter = DateFormatter.defaultInstance
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        date = dateformatter.date(from: dateString) ?? Date()
        title = try values.decode(String.self, forKey: .title)
        id = try values.decode(Int.self, forKey: .id)
    }
}

struct DiariesDto: Decodable {
    let diaries: [SimpleDiaryDto]?
    let timeZone: String?
}
