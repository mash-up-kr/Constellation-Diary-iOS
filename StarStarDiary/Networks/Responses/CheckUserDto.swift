//
//  ResCheckUserDto.swift
//  MashUpAPITest
//
//  Created by 이동영 on 2020/02/06.
//  Copyright © 2020 이동영. All rights reserved.
//

import Foundation

struct CheckUserDto: Decodable {
    let available: Bool
    let userId: String
}

struct FindIDResponse: Decodable {
    let userId: String
}

struct TempTokenResponse: Decodable {
    let token: String
}
