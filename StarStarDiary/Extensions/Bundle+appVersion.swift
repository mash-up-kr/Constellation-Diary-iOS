//
//  Bundle+appVersion.swift
//  StarStarDiary
//
//  Created by suhyun on 2019/12/21.
//  Copyright © 2019 mash-up. All rights reserved.
//

import Foundation

extension Bundle {
    var appVersion: String {
        guard let dictionary = Bundle.main.infoDictionary,
            let version = dictionary["CFBundleShortVersionString"] as? String else {
                return ""
        }
        
        return version
    }
}
