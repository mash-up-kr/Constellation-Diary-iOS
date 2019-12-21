//
//  SettingsViewController+cell.swift
//  StarStarDiary
//
//  Created by suhyun on 2019/12/21.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit

// title은 기본으로 있으나, 오른쪽 Component가 다름
enum SettingsViewCellType {
    case hasOnlyTitle
    case hasSubTitle
    case hasRightSwitch
    case hasRightImage
}

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
    var subTitle: String = ""
    var cellType: SettingsViewCellType
    var isSwitchOn: Bool = false
    var rightImage: UIImage?
    var isHiddenBottomLine: Bool
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
        case amAlerm
        case pmAlarm
        
        // Normal Menu
        case changePMAlaramTime
        case logout
        case appVersion
        
        var sectionMenuType: SectionMenu {
            switch self {
             case .amAlerm,
                  .pmAlarm: return .alarm
             case .changePMAlaramTime,
                  .logout,
                  .appVersion: return .normal
            }
        }
        
        var titleString: String {
            switch self {
            case .amAlerm: return "오전 운세 알람 8:00 AM"
            case .pmAlarm: return "오후 질문 알람 10:00 PM"
            case .changePMAlaramTime: return "오후 알람 시간 변경하기"
            case .logout: return "로그아웃"
            case .appVersion: return "앱 버전"
           }
        }
        
        var subTitleString: String {
            switch self {
            case .amAlerm,
                 .pmAlarm,
                 .changePMAlaramTime,
                 .logout: return ""
            case .appVersion: return "ver \(Bundle.main.appVersion)"
            }
        }

        // TODO: 사용자 데이터 바인딩 필요
        var isSwitchOn: Bool {
           switch self {
           case .amAlerm: return false
           case .pmAlarm: return false
           case .changePMAlaramTime,
                .logout,
                .appVersion: return false
            }
        }
        
        var cellType: SettingsViewCellType {
            switch self {
            case .amAlerm: return .hasRightSwitch
            case .pmAlarm: return .hasRightSwitch
            case .changePMAlaramTime: return .hasRightImage
            case .logout: return .hasOnlyTitle
            case .appVersion: return .hasSubTitle
            }
        }
        
        var rightImage: UIImage? {
            switch self {
            case .amAlerm,
                 .pmAlarm,
                 .logout,
                 .appVersion: return nil
            case .changePMAlaramTime: return UIImage(named: "icArrowIosRight24")
            }
        }
        
        var isHiddenBottomLine: Bool {
            switch self {
            case .amAlerm,
                 .pmAlarm: return true
            case .changePMAlaramTime,
                 .logout,
                 .appVersion: return false
            }
        }
    }
}
