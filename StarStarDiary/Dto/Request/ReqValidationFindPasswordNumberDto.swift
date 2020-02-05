//
//  ReqValidationFindPasswordNumberDto.swift
//  MashUpAPITest
//
//  Created by 이동영 on 2020/02/06.
//  Copyright © 2020 이동영. All rights reserved.
//

import Foundation

struct ReqValidationFindPasswordNumberDto: Encodable {
    let email: String
    let number: Int
    let userId: String
}
