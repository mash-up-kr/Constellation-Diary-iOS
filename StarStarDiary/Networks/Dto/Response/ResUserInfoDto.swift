//
//  ResUserInfoDto.swift
//  MashUpAPITest
//
//  Created by 이동영 on 2020/02/06.
//  Copyright © 2020 이동영. All rights reserved.
//

import Foundation

struct ResUserInfoDto: Decodable {
    let tokens: ResTokenDto
    let user: ResUserDto
}
