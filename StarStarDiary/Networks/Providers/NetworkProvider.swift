//
//  Networking.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/02/09.
//  Copyright © 2020 mash-up. All rights reserved.
//

import Foundation
import Moya

final class NetworkProvider: Provider {
    var provider = MoyaProvider<API>()
    
    
    func authenticationNumbersToFindPassword(email: String,
                                             userId: String,
                                             successHandler: @escaping () -> Void,
                                             errorHandler: @escaping (Error) -> Void) {
        request(.authenticationNumbersToFindPassword(email: email, userId: userId),
                completion: successHandler,
                failure: errorHandler)
    }
    
    func authenticationToFindPassword(email: String,
                                      number: Int,
                                      userId: String,
                                      successHandler: @escaping () -> Void,
                                      errorHandler: @escaping (Error) -> Void) {
        request(.authenticationToFindPassword(email: email, number: number, userId: userId),
                completion: successHandler,
                failure: errorHandler)
    }
    
    func authenticationNumbersToSignUp(email: String,
                                       successHandler: @escaping () -> Void,
                                       errorHandler: @escaping (Error) -> Void) {
        request(.authenticationNumbersToSignUp(email: email),
                completion: successHandler,
                failure: errorHandler)
    }
    
    func authenticationToSignUp(email: String,
                                number: Int,
                                successHandler: @escaping () -> Void,
                                errorHandler: @escaping (Error) -> Void) {
        request(.authenticationToSignUp(email: email, number: number),
                completion: successHandler,
                failure: errorHandler)
    }
    
    func checkId(id: String,
                 successHandler: @escaping (CheckUserDto) -> Void,
                 errorHandler: @escaping (Error) -> Void) {
        request(.checkId(id: id),
                completion: successHandler,
                failure: errorHandler)
    }
    
    func findId(email: String,
                successHandler: @escaping (UserIdDto) -> Void,
                errorHandler: @escaping (Error) -> Void) {
        request(.findId(email: email),
                completion: successHandler,
                failure: errorHandler)
    }
    
    func signIn(fcmToken: String,
                password: String,
                userId: String,
                successHandler: @escaping (UserInfoDto) -> Void,
                errorHandler: @escaping (Error) -> Void) {
        request(.signIn(fcmToken: fcmToken, password: password, userId: userId),
                completion: successHandler,
                failure: errorHandler)
    }
    
}
