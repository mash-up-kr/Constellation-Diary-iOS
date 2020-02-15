//
//  Networking.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/02/09.
//  Copyright © 2020 mash-up. All rights reserved.
//

import Foundation
import Moya

struct Provider {
    private static let provider = MoyaProvider<Service>(plugins: [NetworkLoggerPlugin(verbose: true)])

    // MARK: - API Methods

    static func request<T: Decodable>(_ service: Service, completion: @escaping ResultCompletion<T>, failure: @escaping ((Error) -> Void) = { _ in }) {
        provider.request(service) { result in
            self.task(result, completion: completion, failure: failure)
        }
    }
}

private extension Provider {
    static func task<T: Decodable>(_ result: Result<Moya.Response, MoyaError>, completion: @escaping ((T) -> Void), failure: @escaping ((Error) -> Void)) {
        switch result {
        case .success(let response):
            let statusCode = response.statusCode
            switch statusCode {
            case 200..<300:
                guard let data = try? response.map(T.self) else {
                    preconditionFailure("Fail: \(response) does not found !!")
                }
                completion(data)

            case 400..<500:
                guard let data = try? response.map(ErrorData.self) else {
                    preconditionFailure("Fail: \(response) does not found !!")
                }
                failure(NSError(domain: data.msg ?? "Unknown", code: data.code ?? -9999, userInfo: nil))

            default:
                failure(NSError(domain: "Unknown", code: -9999, userInfo: nil))
            }

        case let .failure(error):
            failure(error)
        }
    }
}








final class NetworkService {
    lazy var provider = MoyaProvider<API>()
    
    func authenticationNumbersToFindPassword(email: String,
                                             userId: String) {
        
    }
    
    func authenticationToFindPassword(email: String,
                                      number: Int,
                                      userId: String,
                                      successHandler: @escaping () -> Void,
                                      errorHandler: @escaping (MoyaError) -> Void) {
        provider.request(.authenticationNumbersToSignUp(email: email)) { result in
            switch result {
            case .success:
                successHandler()
            case .failure(let error):
                errorHandler(error)
            }
        }
    }
    
    func authenticationNumbersToSignUp(email: String,
                                       successHandler: @escaping () -> Void,
                                       errorHandler: @escaping (MoyaError) -> Void) {
        provider.request(.authenticationNumbersToSignUp(email: email)) { result in
            switch result {
            case .success:
                successHandler()
            case .failure(let error):
                errorHandler(error)
            }
        }
    }
    
    func authenticationToSignUp(email: String, number: Int) {
        
    }
    
    func checkId(id: String) {
        
    }
    
    func findId(email: String) {
        
    }
    
    func signIn(fcmToken: String, password: String, userId: String) {
        
    }
    
}
