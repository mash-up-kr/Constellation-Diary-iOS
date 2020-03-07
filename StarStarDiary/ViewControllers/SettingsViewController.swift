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
    
    private var navigationView = BaseNavigationView(frame: .zero)
    private var tableView = UITableView(frame: .zero)
    
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
            $0.register(BaseTableViewCell.self, forCellReuseIdentifier: "BaseTableViewCell")
            $0.register(BaseTableViewHeaderFooterView.self,
                        forHeaderFooterViewReuseIdentifier: "BaseTableViewHeaderFooterView")
            $0.separatorStyle = .none
            $0.bounces = false
        }
    }
    
    private func initVar() {
        for section in SectionMenu.allCases {
            let cellItems = CellMenu.allCases
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

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        for sectionItem in items.sections where sectionItem.index == section {
            return sectionItem.cells.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BaseTableViewCell",
                                                 for: indexPath) as! BaseTableViewCell
        let cellItem = items.sections[indexPath.section].cells[indexPath.row]
        cell.setEntity(titleString: cellItem.title,
                       subTitleString: cellItem.subTitle,
                       valueString: cellItem.value,
                       isSwitchOn: cellItem.isSwitchOn,
                       canSelect: cellItem.canSelect,
                       cellType: cellItem.cellType)
        
        if cellItem.isSwitchOn != nil {
            cell.selectionStyle = .none
            cell.setDatePicker(mode: .time)
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellItem = items.sections[indexPath.section].cells[indexPath.row]
        
        if cellItem.didExtension {
            return 288.0
        } else {
            return 72.0
        }
    }
    
    // MARK: - HeaderFooter
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionItem = items.sections[section]
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseTableViewHeaderFooterView") as! BaseTableViewHeaderFooterView
        view.setEntity(title: sectionItem.title,
                       titleColor: .gray122,
                       font: UIFont.systemFont(ofSize: 12.0))
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionMenuType = SectionMenu(rawValue: section) else {
            return 0.0
        }
        
        switch sectionMenuType {
        case .alarm: return 32.0
        case .normal: return 0.0
        }
    }
    
    // MARK: Event
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cellItem = items.sections[indexPath.section].cells[indexPath.row]
        
        switch cellItem.menu {
        case .logout:
            presentLogoutAlert()
        default:
            ()
        }
    }
}

private extension SettingsViewController {
    
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
        present(alert, animated: true, completion: nil)
    }
    
}
