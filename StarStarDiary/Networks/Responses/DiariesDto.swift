//
//  ResDiariesDto.swift
//  MashUpAPITest
//
//  Created by 이동영 on 2020/02/06.
//  Copyright © 2020 이동영. All rights reserved.
//

import Foundation

struct SimpleDiaryDto: Decodable {
    let id: Int
    let title: String
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case date
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        
        let dateString = try values.decode(String.self, forKey: .date)
        let dateFormatter = DateFormatter.defaultInstance
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000+0000"
        date = dateFormatter.date(from: dateString) ?? Date()
    }
    
}

struct DiariesDto: Decodable {
    let diaries: [SimpleDiaryDto]?
    let timeZone: String?
}
