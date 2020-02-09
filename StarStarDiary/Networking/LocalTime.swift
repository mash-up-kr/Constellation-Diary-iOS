//
//  LocalTime.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/02/09.
//  Copyright © 2020 mash-up. All rights reserved.
//

import Foundation

struct LocalTime: Decodable {
    let hour: Int
    let minute: Int
    let nano: Int
    let second: Int
}
