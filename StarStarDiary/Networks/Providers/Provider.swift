//
//  Provider.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/02/15.
//  Copyright © 2020 mash-up. All rights reserved.
//

import Foundation
import Moya

protocol Provider {
    associatedtype API: TargetType
    
    var provider: MoyaProvider<API> { get }
    
    func request(_ service: API,
                 completion: @escaping () -> Void,
                 failure: @escaping (Error) -> Void)
    func request<T: Decodable>(_ service: API,
                               completion: @escaping (T) -> Void,
                               failure: @escaping ((Error) -> Void))
}

extension Provider {
    
    func request(_ service: API,
                 completion: @escaping () -> Void,
                 failure: @escaping ((Error) -> Void) = { _ in }) {
        provider.request(service) { result in
            switch result {
            case .success:
                completion()
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func request<T: Decodable>(_ service: API,
                               completion: @escaping (T) -> Void,
                               failure: @escaping ((Error) -> Void) = { _ in }) {
        provider.request(service) { result in
            switch result {
            case .success(let response):
                guard let body = try? response.map(T.self) else {
                    failure(NetworkError.decodingFailure(response))
                    return
                }
                
                completion(body)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
}
