//
//  ReqSignInDto.swift
//  MashUpAPITest
//
//  Created by 이동영 on 2020/02/06.
//  Copyright © 2020 이동영. All rights reserved.
//

import Foundation

struct ReqSignInDto: Encodable {
    let fcmToken: String
    let password: String
    let userId: String
}
