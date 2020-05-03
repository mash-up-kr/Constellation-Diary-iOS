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

enum API {
    
    case authenticationNumbersToFindPassword(email: String, userId: String)
    case authenticationToFindPassword(email: String, number: Int, userId: String)
    
    case authenticationNumbersToSignUp(email: String)
    case authenticationToSignUp(email: String, number: Int)
    
    case checkId(userID: String)
    case findId(email: String)
    case signIn(fcmToken: String, password: String, userId: String)
}

extension API: TargetType {
    var timeZone: String {
        return "UTC"
    }
    
    var baseURL: URL {
        URL(string: "https://byeol-byeol.kro.kr")!
    }
    
    var path: String {
        switch self {
        case .authenticationNumbersToFindPassword:
            return "/authentication-numbers/find-password"
        case .authenticationToFindPassword:
            return "/authentication/find-password"
        case .authenticationNumbersToSignUp:
            return "/authentication-numbers/sign-up"
        case .authenticationToSignUp:
            return "/authentication/sign-up"
        case .checkId:
            return "/users/check"
        case .findId:
            return "/users/find-id"
        case .signIn:
            return "/users/sign-in"
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
        case .authenticationNumbersToFindPassword(let email, let userId):
            return .requestParameters(parameters: ["email": email,
                                                   "userId": userId],
                                      encoding: JSONEncoding.default)
        case .authenticationToFindPassword(let email, let number, let userId):
            return .requestParameters(parameters: ["email": email,
                                                   "number": number,
                                                   "userId": userId],
                                      encoding: JSONEncoding.default)
        case .authenticationNumbersToSignUp(let email):
            return .requestParameters(parameters: ["email": email],
                                      encoding: JSONEncoding.default)
        case .authenticationToSignUp(let email, let number):
            return .requestParameters(parameters: ["email": email,
                                                   "number": number],
                                      encoding: JSONEncoding.default)
        case .checkId(let userID):
            return .requestParameters(parameters: ["user-id": userID],
                                      encoding: URLEncoding.default)
        case .findId(let email):
            return .requestParameters(parameters: ["email": email],
                                      encoding: URLEncoding.default)
            
        case .signIn(let fcmToken, let password, let userId):
            return .requestParameters(parameters: ["fcmToken": fcmToken,
                                                   "password": password,
                                                   "userId":userId],
                                      encoding: JSONEncoding.default)
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
