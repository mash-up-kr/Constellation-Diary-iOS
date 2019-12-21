//
//  SettingsViewController.swift
//  StarStarDiary
//
//  Created by Karen on 2019/12/18.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var navigationView: BaseNavigationView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Var
    
    private var items: SettingsViewItem!
    
    // MARK: - Event

    @objc
    private func onClose(sender: AnyObject?) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Init

    private func initNavigationView() {
        let leftTargetType: AddTargetType = (self, #selector(onClose(sender:)), .touchUpInside)

        navigationView.do {
            $0.setBackgroundColor(color: .clear)
            $0.setBtnLeft(image: UIImage(named: "icClose24"), addTargetType: leftTargetType)
            $0.setTitle(title: "설정", titleColor: .black, image: nil)
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
        items = SettingsViewItem()
        
        for section in SectionMenu.allCases {
            var cellItems: [SettingsViewCellItem] = []
            
            for cell in CellMenu.allCases where cell.sectionMenuType == section {
                cellItems.append(SettingsViewCellItem(index: cell.rawValue,
                                          title: cell.titleString,
                                          subTitle: cell.subTitleString,
                                          cellType: cell.cellType,
                                          isSwitchOn: cell.isSwitchOn,
                                          rightImage: cell.rightImage,
                                          isHiddenBottomLine: cell.isHiddenBottomLine))
            }
            
            items.sections.append(SectionItem(index: section.rawValue,
                                              title: section.titleString,
                                              cells: cellItems))
        }
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initNavigationView()
        initTableView()
        initVar()
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
        cell.setEntity(cell: cellItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let sectionMenuType = SectionMenu(rawValue: indexPath.section) {
            switch sectionMenuType {
            case .alarm: return 40.0
            case .normal: return 64.0
            }
        }
    
        return 0.0
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
        if let sectionMenuType = SectionMenu(rawValue: section) {
            switch sectionMenuType {
            case .alarm: return 40.0
            case .normal: return 8.0
            }
        }
        
        return 0.0
    }
    
    // MARK: Event
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
