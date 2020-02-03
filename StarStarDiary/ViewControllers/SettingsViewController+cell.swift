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
    var cellType: BaseTableViewCellType
    var isSwitchOn: Bool?
    var canSelecte: Bool
}

extension SettingsViewController {
   
    // MARK: - Config

    enum SectionMenu: Int, CaseIterable {
        case alarm
        case normal
        
        var titleString: String {
           switch self {
           case .alarm: return "푸시 알림 설정"
           case .normal: return ""
           }
        }
    }
    
    enum CellMenu: Int, CaseIterable {
        // Alarm Menu
        case luckAlerm
        case questionAlarm
        
        // Normal Menu
        case logout
        case appVersion
        case developerInfo
        case feedback
        
        var sectionMenuType: SectionMenu {
            switch self {
            case .luckAlerm,
                 .questionAlarm: return .alarm
            case .logout,
                 .appVersion,
                 .developerInfo,
                 .feedback: return .normal
            }
        }
        
        var titleString: String {
            switch self {
            case .luckAlerm: return "운세 알람"
            case .questionAlarm: return "질문 알람"
            case .logout: return "로그아웃"
            case .appVersion: return "앱 버전"
            case .developerInfo: return "개발자 정보"
            case .feedback: return "피드백 남기기"
           }
        }
        
        // TODO: 데이터 바인딩
        var subTitleString: String? {
            switch self {
            case .luckAlerm: return "오전 08:00"
            case .questionAlarm: return "오후 10:00"
            case .logout: return nil
            case .appVersion: return "업데이트 가능"
            case .developerInfo: return nil
            case .feedback: return nil
            }
        }
        
        var valueString: String? {
            switch self {
            case .luckAlerm: return nil
            case .questionAlarm: return nil
            case .logout: return nil
            case .appVersion: return "ver.\(Bundle.main.appVersion)"
            case .developerInfo: return nil
            case .feedback: return nil
            }
        }

        // TODO: 사용자 데이터 바인딩 필요
        var isSwitchOn: Bool? {
           switch self {
           case .luckAlerm: return false
           case .questionAlarm: return false
           case .logout,
                .appVersion,
                .developerInfo,
                .feedback: return nil
            }
        }
        
        var cellType: BaseTableViewCellType {
            switch self {
            case .luckAlerm: return .hasSwitch
            case .questionAlarm: return .hasSwitch
            case .logout: return .hasOnlyTitle
            case .appVersion: return .hasValue
            case .developerInfo: return .hasArrow
            case .feedback: return .hasArrow
            }
        }
        
        var canSelected: Bool {
            switch self {
            case .luckAlerm: return false
            case .questionAlarm: return false
            case .logout: return true
            case .appVersion: return true
            case .developerInfo: return true
            case .feedback: return true
            }
        }
    }
}
