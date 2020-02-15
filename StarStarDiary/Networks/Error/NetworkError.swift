//
//  NetworkError.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/02/15.
//  Copyright © 2020 mash-up. All rights reserved.
//

import Foundation
import Moya

enum NetworkError: LocalizedError {
    case decodingFailure(Response)
    
    var errorDescription: String? {
        switch self {
        case .decodingFailure(let response):
            return "\(response.self)의 디코딩에 실패했습니다."
        }
    }
}
