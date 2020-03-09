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
    
    // MARK: - Event

    @objc
    private func onClose(sender: AnyObject?) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Init
    
    private func initLayout() {
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

    private func initNavigationView() {
        let leftTargetType: AddTargetType = (self, #selector(onClose(sender:)), .touchUpInside)

        navigationView.do {
            $0.setBackgroundColor(color: .clear)
            $0.setButton(type: .left, image: UIImage(named: "icClose24"), addTargetType: leftTargetType)
            $0.setTitle(title: "설정", titleColor: .black)
            $0.setBottomLine(isHidden: false)
        }
    }
    
    private func initTableView() {
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
    
    private func initVar() {
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

    private func initView() {
        view.backgroundColor = .white
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initLayout()
        initNavigationView()
        initTableView()
        initVar()
        initView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        cell.setEntity(with: items.sections[indexPath.section].cells[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellItem = items.sections[indexPath.section].cells[indexPath.row]
        return cellItem.didExtension ? 288.0 : 72
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
        var cellItem = items.sections[indexPath.section].cells[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch cellItem.menu {
        case .horoscopeNotification, .questionNotification:
            guard let cell = tableView.cellForRow(at: indexPath) as? SettingBaseTableViewCell else {
                return
            }
            cellItem.subTitle = cell.datePickerView.date.description
            cellItem.didExtension.toggle()
            items.sections[indexPath.section].cells[indexPath.row] = cellItem
            tableView.reloadRows(at: [indexPath], with: .automatic)
//            cellItem
        case .logout:
            presentLogoutAlert()
        case .feedback:
            openMail()
        default:
            ()
        }
    }
}

private extension SettingsViewController {
//    func presentEditNotification(type: PushNotificationType) {
//        let editNotificationViewController = EditNotificationViewController()
//        editNotificationViewController.bind(type: type)
//        let navigationController = UINavigationController(rootViewController: editNotificationViewController)
//        navigationController.modalPresentationStyle = .pageSheet
//        present(navigationController, animated: true, completion: nil)
//    }
    
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
    
}
