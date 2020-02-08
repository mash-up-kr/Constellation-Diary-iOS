//
//  API.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/02/08.
//  Copyright © 2020 mash-up. All rights reserved.
//

import Foundation



enum API {
    typealias Token = String
    
    case authenticationNumbersToFindPassword(ReqFindPasswordNumberDto)
    case authenticationToFindPassword(ReqValidationFindPasswordNumberDto)
    
    case authenticationNumbersToSignUp(ReqSignUpNumberDto)
    case authenticationToSignUp(ReqValidationSignUpNumberDto)
    
    case dailyQuestion(autherization: JWT, timeZone: String, date: String)
    
    case diaries(autherization: JWT, timeZone: String, month: Int, year: Int)
    case writeDiary(autherization: JWT, timeZone: String, request: ReqWriteDiaryDto)
    case diary(autherization: JWT, timeZone: String, id: Int)
    case modifyDiary(autherization: JWT, timeZone: String, diaryId: Int, request: ReqModifyDiaryDto)
    case deleteDiary(autherization: JWT, id: Int)
    
    case horoscopes(autherization: JWT, timeZone: String, constellation: String, date: String)
    case horoscope(autherization: JWT, id: Int)
    
    case modifyConstellations(authorization: JWT, timeZone: String, request: ReqModifyConstellationDto)
    case modifyHoroscopeAlarm(authorization: JWT, timeZone: String, request: ReqModifyHoroscopeAlarmDto)
    case modifyHoroscopeTime(authorization: JWT, timeZone: String, request: ReqModifyHoroscopeTimeDto)
    case modifyPassword(authorization: JWT, request: ReqModifyPasswordDto)
    case modifyQuestionAlarm(authorization: JWT, timeZone: String, request: ReqModifyQuestionAlarmDto)
    case modifyQuestionTime(authorization: JWT, timeZone: String, request: ReqModifyQuestionTimeDto)
    
    case checkId(id: String)
    case findId(email: String)
    case signIn(timeZone: String, request: ReqSignInDto)
    case signOut(authorization: JWT)
    case signUp(authorization: JWT, timeZone: String, request: ReqSignUpDto)
    
    case refreshToken(authorization: JWT)
}
