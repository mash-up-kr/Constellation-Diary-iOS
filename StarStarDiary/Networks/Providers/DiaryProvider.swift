//
//  DiaryProvider.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/02/15.
//  Copyright © 2020 mash-up. All rights reserved.
//

import Foundation
import Moya

final class DiaryService: Provider {
    typealias API = DiaryAPI
    
    let provider = MoyaProvider<API>()
    
    func dailyQuestions(date: String,
                        successHandler: @escaping (DailyQuestionDto) -> Void,
                        errorHandler: @escaping (Error) -> Void) {
        request(.dailyQuestions(date: date),
                completion: successHandler,
                failure: errorHandler)
    }
    
    func writeDiary(content: String,
                      date: String,
                      horoscopeId: Int,
                      title: String,
                      successHandler: @escaping (TokenDto) -> Void,
                      errorHandler: @escaping (Error) -> Void) {
        request(.writeDiary(content: content, date: date, horoscopeId: horoscopeId, title: title),
                completion: successHandler,
                failure: errorHandler)
    }
    
    func deleteDiary(id: Int,
                     successHandler: @escaping () -> Void,
                     errorHandler: @escaping (Error) -> Void) {
        request(.deleteDiary(id: id),
                completion: successHandler,
                failure: errorHandler)
    }
    
    
    func diaries(month: Int,
                 year: Int,
                 successHandler: @escaping (DiariesDto) -> Void,
                 errorHandler: @escaping (Error) -> Void) {
        request(.diaries(month: month, year: year),
                completion: successHandler,
                failure: errorHandler)
    }
    
    func diary(id: Int,
               successHandler: @escaping (DiaryDto) -> Void,
               errorHandler: @escaping (Error) -> Void) {
        request(.diary(id: id),
                completion: successHandler,
                failure: errorHandler)
    }
    
    func horoscope(id: Int,
                   successHandler: @escaping (HoroscopeDto) -> Void,
                   errorHandler: @escaping (Error) -> Void) {
        request(.horoscope(id: id),
                completion: successHandler,
                failure: errorHandler)
    }
    
    func horoscopes(constellation: String, date: String,
                    successHandler: @escaping (HoroscopeDto) -> Void,
                    errorHandler: @escaping (Error) -> Void) {
        request(.horoscopes(constellation: constellation, date: date),
                completion: successHandler,
                failure: errorHandler)
    }
    
    func modifyConstellations(constellation: String,
                              successHandler: @escaping (UserDto) -> Void,
                              errorHandler: @escaping (Error) -> Void) {
        request(.modifyConstellations(constellation: constellation),
                completion: successHandler,
                failure: errorHandler)
    }
    
    func modifyHoroscopeTime(date: String,
                             successHandler: @escaping (UserDto) -> Void,
                             errorHandler: @escaping (Error) -> Void) {
        request(.modifyHoroscopeTime(date: date),
                completion: successHandler,
                failure: errorHandler)
    }
    
    func modifyHoroscopeAlarm(horoscopeAlarm: Bool,
                              successHandler: @escaping (UserDto) -> Void,
                              errorHandler: @escaping (Error) -> Void) {
        request(.modifyHoroscopeAlarm(horoscopeAlarm: horoscopeAlarm),
                completion: successHandler,
                failure: errorHandler)
    }
    
    func modifyPassword(password: String,
                        successHandler: @escaping () -> Void,
                        errorHandler: @escaping (Error) -> Void) {
        request(.modifyPassword(password: password),
                completion: successHandler,
                failure: errorHandler)
    }
    
    func modifyQuestionTime(date: String,
                            successHandler: @escaping (UserDto) -> Void,
                            errorHandler: @escaping (Error) -> Void) {
        request(.modifyQuestionTime(date: date),
                completion: successHandler,
                failure: errorHandler)
    }
    
    func modifyQuestionAlarm(modifyQuestionAlarm: Bool,
                             successHandler: @escaping (UserDto) -> Void,
                             errorHandler: @escaping (Error) -> Void) {
        request(.modifyQuestionAlarm(modifyQuestionAlarm: modifyQuestionAlarm),
                completion: successHandler,
                failure: errorHandler)
    }
    
    func signOut(successHandler: @escaping (UserDto) -> Void,
                 errorHandler: @escaping (Error) -> Void) {
        request(.signOut,
                completion: successHandler,
                failure: errorHandler)
    }
    
    func signUp(constellation: String,
                email: String,
                password: String,
                userId: String,
                successHandler: @escaping (UserDto) -> Void,
                errorHandler: @escaping (Error) -> Void) {
        request(.signUp(constellation: constellation, email: email, password: password, userId: userId),
                completion: successHandler,
                failure: errorHandler)
    }
    
    func refreshToken(successHandler: @escaping (TokenDto) -> Void,
                      errorHandler: @escaping (Error) -> Void) {
        request(.refreshToken,
                completion: successHandler,
                failure: errorHandler)
    }
    
}

