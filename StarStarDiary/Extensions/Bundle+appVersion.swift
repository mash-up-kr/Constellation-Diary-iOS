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
    
    var hasUpdateVersion: Bool {
        guard let url = URL(string: "http://itunes.apple.com/lookup?bundleId=내번들ID"),
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
            let results = json["results"] as? [[String: Any]],
            results.isEmpty == false,
            let appStoreVersion = results[0]["version"] as? String else {
                return false
        }
        return self.appVersion != appStoreVersion
    }

}
