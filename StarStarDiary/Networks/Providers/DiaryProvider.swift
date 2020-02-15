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
    
    func horoscope(constellation: String, date: String,
               successHandler: @escaping (Dto) -> Void,
               errorHandler: @escaping (Error) -> Void) {
        request(.horoscopes(constellation: constellation, date: date),
                completion: successHandler,
                failure: errorHandler)
    }
    
    
}

