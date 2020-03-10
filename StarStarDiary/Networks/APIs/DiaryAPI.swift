//
//  AuthenticatedAPI.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/02/08.
//  Copyright © 2020 mash-up. All rights reserved.
//

import Foundation
import Moya

protocol Authenticated {
    typealias Token = String
    
    var accessToken: Token { get }
    var refreshToken: Token { get }
}

enum DiaryAPI {
    case users
    
    case dailyQuestions
    case diaries(month: Int, year: Int)
    case writeDiary(content: String, horoscopeId: Int, title: String)
    case diary(id: Int)
    case modifyDiary(id: Int, content: String, title: String)
    case deleteDiary(id: Int)
    
    case horoscopes(constellation: String, date: Date)
    case horoscope(id: Int)
    
    case modifyPassword(password: String)
    
    case modifyConstellations(constellation: String)
    case modifyHoroscopeAlarm(isOn: Bool)
    case modifyHoroscopeTime(date: Date)
    case modifyQuestionAlarm(isOn: Bool)
    case modifyQuestionTime(date: Date)
    
    case signOut
    case signUp(constellation: String, email: String, password: String, userId: String)
    
    case refreshToken
}

extension DiaryAPI: Authenticated {
    var accessToken: Token {
        return "Bearer \(UserDefaults.currentToken ?? "cbbb1a6e-8614-4a4d-a967-b0a42924e7ca")"
    }
    
    var refreshToken: Token {
        return "Bearer \(UserDefaults.refreshToken ?? "")"
    }
    
    var timeZone: String {
        return "UTC"
    }
}

extension DiaryAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://byeol-byeol.kro.kr")!
    }
    
    var path: String {
        switch self {
        case .users:
            return "/users"
        case .dailyQuestions:
            return "/daily-questions"
        case .diaries:
            return "/diaries"
        case .writeDiary:
            return "/diaries"
        case .diary(let id):
            return "/diaries/\(id)"
        case .modifyDiary(let id, _, _):
            return "/diaries/\(id)"
        case .deleteDiary(let id):
            return "/diaries/\(id)"
        case .horoscopes:
            return "/horoscopes"
        case .horoscope(let id):
            return "/horoscopes/\(id)"
        case .modifyConstellations:
            return "/users/constellations"
        case .modifyHoroscopeAlarm:
            return "/users/horoscope-alarm"
        case .modifyHoroscopeTime:
            return "/users/horoscope-time"
        case .modifyPassword:
            return "/users/password"
        case .modifyQuestionAlarm:
            return "/users/question-alarm"
        case .modifyQuestionTime:
            return "/users/question-time"
        case .signOut:
            return "/users/sign-out"
        case .signUp:
            return "/users/sign-up"
        case .refreshToken:
            return "/users/tokens"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .dailyQuestions,
             .diaries,
             .diary,
             .horoscopes,
             .horoscope,
             .refreshToken,
             .users:
            return .get
        case .writeDiary,
             .signOut,
             .signUp:
            return .post
        case .modifyDiary,
             .modifyConstellations,
             .modifyHoroscopeAlarm,
             .modifyHoroscopeTime,
             .modifyPassword,
             .modifyQuestionAlarm,
             .modifyQuestionTime:
            return .patch
        case .deleteDiary:
            return .delete
        }
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: Task {
        switch self {
        case .users, .diary, .horoscope, .signOut, .refreshToken:
            return .requestPlain
        case .dailyQuestions:
            return .requestParameters(parameters: ["date": Date().utc],
                                      encoding: URLEncoding.default)
        case .diaries(let month, let year):
            return .requestParameters(parameters: ["month": month,
                                                   "year": year],
                                      encoding: URLEncoding.default)
        case .writeDiary(let content,let horoscopeId, let title):
            return .requestParameters(parameters: ["content": content,
                                                   "date": Date().utc,
                                                   "horoscopeId": horoscopeId,
                                                   "title": title],
                                      encoding: JSONEncoding.default)
        case .modifyDiary( _, let content, let title):
            return .requestParameters(parameters: ["content": content,
                                                   "title": title],
                                      encoding: JSONEncoding.default)
        case .deleteDiary:
            return .requestPlain
        case .horoscopes(let constellation, let date):
            return .requestParameters(parameters: ["constellation": constellation,
                                                   "date": date.utc],
                                      encoding: URLEncoding.default)
        case .modifyConstellations(let constellation):
            return .requestParameters(parameters: ["constellation": constellation],
                                      encoding: JSONEncoding.default)
        case .modifyHoroscopeAlarm(let isOn):
            return .requestParameters(parameters: ["horoscopeAlarm": isOn],
                                      encoding: JSONEncoding.default)
        case .modifyHoroscopeTime(let date), .modifyQuestionTime(let date):
            return .requestParameters(parameters: ["date": date.utc],
                                      encoding: JSONEncoding.default)
        case .modifyPassword(let password):
            return .requestParameters(parameters: ["password": password],
                                      encoding: JSONEncoding.default)
        case .modifyQuestionAlarm(let isOn):
            return .requestParameters(parameters: ["modifyQuestionAlarm": isOn],
                                      encoding: JSONEncoding.default)
        case .signUp(let constellation, let email, let password, let userId):
            return .requestParameters(parameters: ["constellation": constellation,
                                                   "email": email,
                                                   "password": password,
                                                   "userId": userId],
                                      encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .users,
             .dailyQuestions,
             .diaries,
             .writeDiary,
             .diary,
             .modifyDiary,.horoscopes,
             .modifyConstellations,
             .modifyHoroscopeAlarm,
             .modifyHoroscopeTime,
             .modifyQuestionAlarm,
             .modifyQuestionTime,
             .signUp:
            return ["Authorization": accessToken,
                    "Time-Zone": timeZone]
        case .deleteDiary,
             .horoscope,
             .modifyPassword,
             .signOut:
            return ["Authorization": accessToken]
        case .refreshToken:
            return ["Authorization": refreshToken]
        }
    }
}
