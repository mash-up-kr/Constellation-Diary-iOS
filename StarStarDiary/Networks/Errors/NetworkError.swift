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

struct ErrorResponse: Decodable {
    let error: ErrorData
}

struct ErrorData: Decodable, Error {
    let code: ErrorCode
    let httpStatus: String?
    let message: String?

    init(code: Int?, httpStatus: String?, message: String?) {
        guard let code = code else {
            preconditionFailure("No erroCode")
        }
        self.code = ErrorCode(rawValue: code) ?? .none
        self.httpStatus = httpStatus
        self.message = message
    }

}

enum ErrorCode: Int, Decodable {
    case none
    case missingParam = 4001
    case noResult = 4002
    case notFoundID = 4003
    case invalidConstellation = 4005
    case existUserID = 4006
    case existEmail = 4009
    case unauthorized = 4101
    case invalidCode = 4102
    case unauthorizedNoExistUserID = 4104
    case noData = 4007
    case loginFail = 4105
}
