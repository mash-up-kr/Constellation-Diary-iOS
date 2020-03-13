//
//  SettingsViewController.swift
//  StarStarDiary
//
//  Created by Karen on 2019/12/18.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    
    private let headerFooterViewIdentifier = "BaseTableViewHeaderFooterView"
    private let cellIdentifier = "BaseTableViewCell"
    private let navigationView = BaseNavigationView(frame: .zero)
    private let tableView = UITableView(frame: .zero)
    
    // MARK: - Var
    
    private var items = SettingsViewItem()
    private var horoscopeTime: Date = UserManager.share.user?.horoscopeTime.date ?? Date()
    private var questionTime: Date = UserManager.share.user?.questionTime.date ?? Date()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initLayout()
        initNavigationView()
        initTableView()
        initVar()
        initView()
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.sections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SettingBaseTableViewCell else {
            preconditionFailure("Cannot typecast dequeueReusableCell with \(cellIdentifier) to BaseTableViewCell for \(indexPath)")
        }
        var item = cellItem(for: indexPath)
        if item.menu == .horoscopeNotification {
            cell.datePickerView.date = horoscopeTime
            item.subTitle = item.isOn ? horoscopeTime.time : ""
        } else if item.menu == .questionNotification {
            cell.datePickerView.date = questionTime
            item.subTitle = item.isOn ? questionTime.time : ""
        }
        cell.setEntity(with: item)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellItem(for: indexPath).didExtension ? 288.0 : 72
    }
    
    // MARK: - HeaderFooter
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerFooterViewIdentifier) as? BaseTableViewHeaderFooterView else {
            return nil
        }
        let sectionItem = items.sections[section]
        view.setEntity(title: sectionItem.title,
                       titleColor: .gray122,
                       font: UIFont.systemFont(ofSize: 12.0))

        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionMenuType = SettingSectionType(rawValue: section) else {
            return 0.0
        }
        return sectionMenuType.headerViewHeight
    }
    
    // MARK: Event
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cellItem = self.cellItem(for: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch cellItem.menu {
        case .horoscopeNotification, .questionNotification:
            cellItem.didExtension.toggle()
            updateItem(at: indexPath, with: cellItem)
        case .logout:
            presentLogoutAlert()
        case .feedback:
            openMail()
        case .developerInfo:
            presetDeveloperInfoAlert()
        case .appVersion:
            return
        }
    }

}

extension SettingsViewController: SettingBaseTableViewCellDelegate {
    func settingBaseTableViewCell(_ cell: SettingBaseTableViewCell, didChange uiSwitch: UISwitch) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        var item = self.cellItem(for: indexPath)
        item.isOn = uiSwitch.isOn
        item.didExtension = uiSwitch.isOn
        switch item.menu {
        case .horoscopeNotification:
            item.subTitle = uiSwitch.isOn ? horoscopeTime.time : ""
            Provider.request(.modifyHoroscopeAlarm(isOn: uiSwitch.isOn), completion: { (data: UserDto) in
                UserManager.share.login(with: data)
            })
        case .questionNotification:
            item.subTitle = uiSwitch.isOn ? questionTime.time : ""
            Provider.request(.modifyQuestionAlarm(isOn: uiSwitch.isOn), completion: { (data: UserDto) in
                UserManager.share.login(with: data)
            })
        default:
            return
        }
        updateItem(at: indexPath, with: item)
    }
    
    func settingBaseTableViewCell(_ cell: SettingBaseTableViewCell, didChange datePicker: UIDatePicker) {
        let pickerDate = Calendar.current.dateComponents(in: TimeZone.current, from: datePicker.date)
        guard let indexPath = self.tableView.indexPath(for: cell),
            let hour = pickerDate.hour,
            let minute = pickerDate.minute else { return }
        var item = self.cellItem(for: indexPath)
        guard let date = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date()) else { return }
        item.subTitle = date.time
        cell.setEntity(with: item)
        switch item.menu {
        case .horoscopeNotification:
            self.horoscopeTime = date
            Provider.request(.modifyHoroscopeTime(date: date), completion: { (data: UserDto) in
                UserManager.share.login(with: data)
            })
        case .questionNotification:
            self.questionTime = date
            Provider.request(.modifyQuestionTime(date: date), completion: { (data: UserDto) in
                UserManager.share.login(with: data)
            })
        default:
            return
        }
    }
    
}

private extension SettingsViewController {
    
    func updateItem(at indexPath: IndexPath, with item: SettingsViewCellItem) {
        items.sections[indexPath.section].cells[indexPath.row] = item
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func cellItem(for indexPath: IndexPath) -> SettingsViewCellItem {
        return items.sections[indexPath.section].cells[indexPath.row]
    }
    
    func openMail() {
        let email = "caution.dev@gmail.com"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    
    func presentLogoutAlert() {
        let alert = UIAlertController(title: nil, message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            Provider.request(.signOut, completion: { success in
                if success {
                    UserDefaults.currentToken = nil
                    UserDefaults.refreshToken = nil
                    UserDefaults.fcmToken = nil
                    let onBoardingViewController = OnBoardingViewController()
                    
                    UIView.transition(from: self.view,
                                      to: onBoardingViewController.view,
                                      duration: 0.3,
                                      options: [.transitionCrossDissolve],
                                      completion: { _ in
                                        self.view.window?.rootViewController = onBoardingViewController
                                    })
                }
            })
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func presetDeveloperInfoAlert() {
        let alert = UIAlertController(title: "안녕하세요, 별별일기 팀입니다.",
                                      message: """
                                                저희는 개발 동아리인 Mash Up 8기 활동으로 이 프로젝트를 진행했습니다.
                                                즐겁게 써주시고, 좋은 의견 부탁드립니다. 감사합니다 :)
                                                디자이너: 이정은, 남궁욱, 고은이
                                                백엔드: 이동준, 신혜란
                                                iOS: 김주희, 임수현, 이동영
                                                Android: 이해창, 이진성, 최민정
                                                """,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Event

    @objc
    func onClose(sender: AnyObject?) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Init
    
    func initLayout() {
        view.addSubview(navigationView)
        view.addSubview(tableView)
        
        navigationView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44.0)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(navigationView.snp.bottom)
        }
    }

    func initNavigationView() {
        let leftTargetType: AddTargetType = (self, #selector(onClose(sender:)), .touchUpInside)

        navigationView.do {
            $0.setBackgroundColor(color: .clear)
            $0.setButton(type: .left, image: UIImage(named: "icClose24"), addTargetType: leftTargetType)
            $0.setTitle(title: "설정", titleColor: .black)
            $0.setBottomLine(isHidden: false)
        }
    }
    
    func initTableView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .clear
            $0.register(SettingBaseTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
            $0.register(BaseTableViewHeaderFooterView.self,
                        forHeaderFooterViewReuseIdentifier: headerFooterViewIdentifier)
            $0.separatorStyle = .none
            $0.bounces = false
        }
    }
    
    func initVar() {
        for section in SettingSectionType.allCases {
            let cellItems = SettingCellType.allCases
                .filter { $0.sectionMenuType == section }
                .map {
                    settingsViewCellItem(with: $0)
            }
            
            items.sections.append(SectionItem(index: section.rawValue,
                                              title: section.titleString,
                                              cells: cellItems))
        }
    }

    func initView() {
        view.backgroundColor = .white
    }
}
