//
//  MoyaProvider.swift
//  StarStarDiary
//
//  Created by juhee on 2020/02/17.
//  Copyright © 2020 mash-up. All rights reserved.
//

import Foundation
import Moya
import Result

typealias ResultCompletion<T: Decodable> = ((T) -> Void)

struct Provider {
    private static let provider = MoyaProvider<API>(plugins: [NetworkLoggerPlugin(verbose: true)])
    private static let diaryProvider = MoyaProvider<DiaryAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    private static var defaultFailureHandler: ((Error) -> Void) {
        return ({ error in
            print("\(#function) - defaultFailureHandler with \(error)")
        })
    }

    // MARK: - API Methods
    
    static func request(_ service: API, completion: @escaping ((Bool) -> Void), failure: @escaping ((ErrorData) -> Void) = defaultFailureHandler) {
        provider.request(service) {
            self.task($0, completion: completion, failure: failure)
        }
    }
    
    static func request(_ service: DiaryAPI, completion: @escaping ((Bool) -> Void), failure: @escaping ((ErrorData) -> Void) = defaultFailureHandler) {
        diaryProvider.request(service) {
            self.task($0, completion: completion, failure: failure)
        }
    }

    static func request<T: Decodable>(_ service: API, completion: @escaping ResultCompletion<T>, failure: @escaping ((ErrorData) -> Void) = defaultFailureHandler) {
        provider.request(service) { result in
            self.task(result, completion: completion, failure: failure)
        }
    }
    
    static func request<T: Decodable>(_ service: DiaryAPI, completion:  @escaping ResultCompletion<T>, failure: @escaping ((ErrorData) -> Void) = defaultFailureHandler) {
        diaryProvider.request(service) { result in
            self.task(result, completion: completion, failure: failure)
        }
    }

}

private extension Provider {
    
    static func task<T: Decodable>(_ result: Result<Moya.Response, MoyaError>, completion: ResultCompletion<T>, failure: @escaping ((ErrorData) -> Void)) {
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
                failure(data)

            default:
                failure(ErrorData(code: -9999, httpStatus: "Unknown", massage: nil))
            }

        case let .failure(error):
            failure(ErrorData(code: error.errorCode, httpStatus: "failure", massage: nil))
        }
    }
    
    static func task(_ result: Result<Moya.Response, MoyaError>, completion: @escaping ((Bool) -> Void), failure: @escaping ((ErrorData) -> Void)) {
        switch result {
        case .success(let response):
            let statusCode = response.statusCode
            switch statusCode {
            case 200..<300:
                completion(true)
            case 400..<500:
                guard let data = try? response.map(ErrorData.self) else {
                    preconditionFailure("Fail: \(response) does not found !!")
                }
                failure(data)
            default:
                failure(ErrorData(code: -9999, httpStatus: "Unknown", massage: nil))
            }
        case let .failure(error):
            failure(ErrorData(code: error.errorCode, httpStatus: "failure", massage: nil))
        }
    }

}
