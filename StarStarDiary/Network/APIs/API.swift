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
