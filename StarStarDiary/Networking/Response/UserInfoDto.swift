//
//  ResUserInfoDto.swift
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
