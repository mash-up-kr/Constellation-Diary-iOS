//
//  ReqWriteDiaryDto.swift
//  MashUpAPITest
//
//  Created by 이동영 on 2020/02/06.
//  Copyright © 2020 이동영. All rights reserved.
//

import Foundation

struct ReqWriteDiaryDto: Encodable {
    let content: String
    let date: String
    let horoscopeId: Int
    let title: String
}
