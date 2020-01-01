//
//  Diary.swift
//  StarStarDiary
//
//  Created by juhee on 2019/12/31.
//  Copyright © 2019 mash-up. All rights reserved.
//

import Foundation

struct Diary: Codable {
    let date: Date
    let title: String
    let content: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let dateString = try values.decode(String.self, forKey: .date)
        let dateformatter = DateFormatter.defaultInstance
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        date = dateformatter.date(from: dateString) ?? Date()
        title = try values.decode(String.self, forKey: .title)
        content = try values.decode(String.self, forKey: .content)
    }

}

struct MontlyDiary: Codable {
    let month: String
    var diary: [Diary]
}

let sampleDiary: [MontlyDiary] = {
    let resourceName = "Sample"
    guard let path = Bundle.main.path(forResource: resourceName, ofType: "json") else {
        preconditionFailure("\(#function) : - Cannot found resource from bundle with named \(resourceName)")
    }

    do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        
        let jsonResult = try JSONDecoder().decode([MontlyDiary].self, from: data)
        
        return jsonResult
    } catch let error {
        preconditionFailure("\(#function) : - Cannot decode data with error : \(error)")
    }

}()
