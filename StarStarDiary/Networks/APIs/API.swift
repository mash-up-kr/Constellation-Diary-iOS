//
//  API.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/02/08.
//  Copyright © 2020 mash-up. All rights reserved.
//

import Foundation
import Moya

typealias Token = String
typealias TimeZone = String

enum API {
    case authenticationNumbersToFindPassword(ReqFindPasswordNumberDto)
    case authenticationToFindPassword(ReqValidationFindPasswordNumberDto)
    
    case authenticationNumbersToSignUp(ReqSignUpNumberDto)
    case authenticationToSignUp(ReqValidationSignUpNumberDto)
    
    case checkId(id: String)
    case findId(email: String)
    case signIn(request: ReqSignInDto)
}

extension API: TargetType {
    var timeZone: TimeZone {
        // FIXME: 현재 타임존으로 설정
        return "KST"
    }
    
    var baseURL: URL {
        URL(string: "https://byeol-byeol.kro.kr/")!
    }
    
    var path: String {
        switch self {
        case .authenticationNumbersToFindPassword:
            return "authentication-numbers/find-password"
        case .authenticationToFindPassword:
            return "authentication/find-password"
        case .authenticationNumbersToSignUp:
            return "authentication-numbers/sign-up"
        case .authenticationToSignUp:
            return "authentication/sign-up"
        case .checkId:
            return "users/check"
        case .findId:
            return "users/find-id"
        case .signIn:
            return "users/sign-in"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkId,
             .findId:
            return .get
        case .authenticationNumbersToFindPassword,
             .authenticationToFindPassword,
             .authenticationNumbersToSignUp,
             .authenticationToSignUp,
             .signIn:
            return .post
        }
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: Task {
        switch self {
        case .authenticationNumbersToFindPassword(let dto):
            return .requestJSONEncodable(dto)
        case .authenticationToFindPassword(let dto):
            return .requestJSONEncodable(dto)
        case .authenticationNumbersToSignUp(let dto):
            return .requestJSONEncodable(dto)
        case .authenticationToSignUp(let dto):
            return .requestJSONEncodable(dto)
        case .checkId(let id):
            return .requestParameters(parameters: ["user-id": id],
                                      encoding: URLEncoding.default)
        case .findId(let email):
            return .requestParameters(parameters: ["email": email],
                                      encoding: URLEncoding.default)
        case .signIn(let dto):
            return .requestJSONEncodable(dto)
        }
    }
    
    var headers: [String : String]? {
        var headers = ["Content-type": "application/json"]
        switch self {
        case .signIn:
            headers["Time-Zone"] = timeZone
        default: ()
        }
        return headers
    }
}
