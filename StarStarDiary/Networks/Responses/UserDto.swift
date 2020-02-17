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

struct UserDto: Decodable {
    let constellation: String
    let horoscopeAlarmFlag: Bool
    let horoscopeTime: LocalTime
    let id: Int
    let questionAlarmFlag: Bool
    let questionTime: LocalTime
    let timeZone: String
    let userId: String
}

struct SimpleResponse: Codable {
    
}
