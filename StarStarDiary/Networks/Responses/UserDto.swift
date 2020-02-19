//
//  ResUserDto.swift
//  MashUpAPITest
//
//  Created by 이동영 on 2020/02/06.
//  Copyright © 2020 이동영. All rights reserved.
//

import Foundation

struct UserInfoDto: Decodable {
    let tokens: TokenDto
    let user: UserDto
}

struct UserIdDto: Decodable {
    let userId: String
}

struct TokenDto: Decodable {
    let authenticationToken: String
    let refreshToken: String
}

struct UserDto: Codable {
    let constellation: String
    let horoscopeAlarmFlag: Bool
    let horoscopeTime: LocalTime
    let id: Int
    let questionAlarmFlag: Bool
    let questionTime: LocalTime
    let timeZone: String
    let userId: String

    enum CodingKeys: String, CodingKey {
        case constellation
        case horoscopeAlarmFlag
        case horoscopeTime
        case id
        case questionAlarmFlag
        case questionTime
        case timeZone
        case userId
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        constellation = try values.decode(String.self, forKey: .constellation)
        horoscopeAlarmFlag = try values.decode(Bool.self, forKey: .horoscopeAlarmFlag)
        id = try values.decode(Int.self, forKey: .id)
        timeZone = try values.decode(String.self, forKey: .timeZone)
        questionAlarmFlag = try values.decode(Bool.self, forKey: .questionAlarmFlag)
        userId = try values.decode(String.self, forKey: .userId)
        
        let questionTimeString = try values.decode(String.self, forKey: .questionTime)
        questionTime = LocalTime(time: questionTimeString)
        let horoscopeTimeString = try values.decode(String.self, forKey: .horoscopeTime)
        horoscopeTime = LocalTime(time: horoscopeTimeString)
    }

}

struct SimpleResponse: Codable {
    
}
