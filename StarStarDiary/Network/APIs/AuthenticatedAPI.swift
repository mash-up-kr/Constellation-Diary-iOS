//
//  AuthenticatedAPI.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/02/08.
//  Copyright © 2020 mash-up. All rights reserved.
//

import Foundation

protocol Authenticated {
    var accessToken: Token { get }
    var refreshToken: Token { get }
}

enum AuthenticatedAPI {
    case dailyQuestion(date: String)
    
    case diaries(month: Int, year: Int)
    case writeDiary(request: ReqWriteDiaryDto)
    case diary(id: Int)
    case modifyDiary(id: Int, request: ReqModifyDiaryDto)
    case deleteDiary(id: Int)
    
    case horoscopes(constellation: String, date: String)
    case horoscope(id: Int)
    
    case modifyConstellations(request: ReqModifyConstellationDto)
    case modifyHoroscopeAlarm(request: ReqModifyHoroscopeAlarmDto)
    case modifyHoroscopeTime(request: ReqModifyHoroscopeTimeDto)
    case modifyPassword(request: ReqModifyPasswordDto)
    case modifyQuestionAlarm(request: ReqModifyQuestionAlarmDto)
    case modifyQuestionTime(request: ReqModifyQuestionTimeDto)
    
    case signOut
    case signUp(request: ReqSignUpDto)
    
    case refreshToken
}

extension AuthenticatedAPI: Authenticated {
    var accessToken: Token {
        return "Bearer cbbb1a6e-8614-4a4d-a967-b0a42924e7ca"
    }
    
    var refreshToken: Token {
        return ""
    }
}
