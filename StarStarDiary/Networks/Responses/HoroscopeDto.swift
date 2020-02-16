//
//  ResHoroscopeDto.swift
//  MashUpAPITest
//
//  Created by 이동영 on 2020/02/06.
//  Copyright © 2020 이동영. All rights reserved.
//

import Foundation

struct HoroscopeDto: Decodable {
    let constellation: String
    let content: String
    let date: String
    let exercise: String
    let id: Int
    let numeral: String
    let stylist: String
    let word: String
}
