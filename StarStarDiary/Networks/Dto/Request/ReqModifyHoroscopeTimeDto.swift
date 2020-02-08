//
//  ReqModifyHoroscopeTimeDto.swift
//  MashUpAPITest
//
//  Created by 이동영 on 2020/02/06.
//  Copyright © 2020 이동영. All rights reserved.
//

import Foundation

struct ReqModifyHoroscopeTimeDto: Encodable {
    let date: String
}
//
//protocol JSONObjectConvertible: Encodable {
//    func asJSONObject() -> [String: String]
//}
//extension JSONObjectConvertible {
//    func asJSONObject() -> [String: String] {
//        let data = try? JSONEncoder().encode(self)
//        return try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: String]
//    }
//}

