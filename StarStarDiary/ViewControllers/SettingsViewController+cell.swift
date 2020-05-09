//
//  SettingsViewController+cell.swift
//  StarStarDiary
//
//  Created by suhyun on 2019/12/21.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit

// SettingsViewItem : TableView item 에 관련된 data를 저장
struct SettingsViewItem {
    var sections: [SectionItem] = []
}

struct SectionItem {
    var index: Int
    var title: String
    var cells: [SettingsViewCellItem] = []
}

struct SettingsViewCellItem {
    var index: Int
    var title: String
    var subTitle: String?
    var value: String?
    var cellType: SettingBaseTableViewCellType
    var menu: SettingCellType
    var didExtension: Bool = false
    var isOn: Bool
}

enum SettingSectionType: Int, CaseIterable {
    case notification
    case appSetting
    
    var titleString: String {
       switch self {
       case .notification: return "푸시 알림 설정"
       case .appSetting: return ""
       }
    }
    
    var headerViewHeight: CGFloat {
        return 32.0
    }
}

enum SettingCellType: Int, CaseIterable {
    // notification Menu
    case horoscopeNotification
    case questionNotification
    
    // appSetting Menu
    case logout
    case appVersion
    case developerInfo
    case feedback
    
    var sectionMenuType: SettingSectionType {
        switch self {
        case .horoscopeNotification, .questionNotification:
            return .notification
        case .logout, .appVersion, .developerInfo, .feedback:
            return .appSetting
        }
    }
    
    var titleString: String {
        switch self {
        case .horoscopeNotification: return "운세 알람"
        case .questionNotification: return "질문 알람"
        case .logout: return "로그아웃"
        case .appVersion: return "앱 버전"
        case .developerInfo: return "개발자 정보"
        case .feedback: return "피드백 남기기"
       }
    }

    var subTitleString: String? {
        guard let user = UserManager.share.user else {
            print("\(#function) :- No User Data")
            return nil
        }
        switch self {
        case .horoscopeNotification: return user.horoscopeTime.date.shortTime
        case .questionNotification: return user.questionTime.date.shortTime
        case .appVersion: return Bundle.main.hasUpdateVersion ? "업데이트 가능" : nil
        case .logout, .developerInfo, .feedback: return nil
        }
    }
    
    var valueString: String? {
        switch self {
        case .appVersion: return "ver.\(Bundle.main.appVersion)"
        default: return nil
        }
    }
    
    var cellType: SettingBaseTableViewCellType {
        switch self {
        case .horoscopeNotification: return .hasSwitch
        case .questionNotification: return .hasSwitch
        case .logout: return .hasOnlyTitle
        case .appVersion: return .hasValue
        case .developerInfo: return .hasArrow
        case .feedback: return .hasOnlyTitle
        }
    }
    
    var isOn: Bool {
        guard let user = UserManager.share.user else {
            print("\(#function) :- No User Data")
            return false
        }
        switch self {
        case .horoscopeNotification: return user.horoscopeAlarmFlag
        case .questionNotification: return user.questionAlarmFlag
        default:
            return false
        }
    }

}

extension SettingsViewController {
   
    // MARK: - Config
    
    func settingsViewCellItem(with menu: SettingCellType) -> SettingsViewCellItem {
        return SettingsViewCellItem(index: menu.rawValue,
                                    title: menu.titleString,
                                    subTitle: menu.subTitleString,
                                    value: menu.valueString,
                                    cellType: menu.cellType,
                                    menu: menu,
                                    isOn: menu.isOn)
    }
}
