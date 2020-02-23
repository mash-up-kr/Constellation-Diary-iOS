//
//  DiaryListViewController.swift
//  StarStarDiary
//
//  Created by suhyun on 2019/12/22.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit
import SnapKit


final class DiaryListViewController: UIViewController {
    
    private let navigationView = BaseNavigationView(frame: .zero)
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    private let reuseIdentifier: String = "diary_cell"
    
    // MARK: - Vars
    
    // FIXME: mock up data
    private var monthlyDiary = sampleDiary
    
    // MARK: - Init
    
    private func initLayout() {
        view.addSubview(navigationView)
        view.addSubview(tableView)
        
        navigationView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44.0)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(navigationView.snp.bottom)
        }
    }
    
    private func initNavigationView() {
        navigationView.do {
            $0.setTitle(title: "일기장", titleColor: .black)
            $0.setBackgroundColor(color: .white)
            
            let leftTargetType: AddTargetType = (self,
                                                 #selector(didTapClose(sender:)),
                                                 .touchUpInside)
            $0.setButton(type: .left, image: UIImage(named: "icClose24"), addTargetType: leftTargetType)
            
            let rightTargetType: AddTargetType = (self,
                                                  #selector(didTapCalendar(sender:)),
                                                  .touchUpInside)
            $0.setButton(type: .right, image: UIImage(named: "icCalendar24"), addTargetType: rightTargetType)
        }
        
    }
    
    private func initView() {
        view.backgroundColor = .white
    }
    
    private func initTableView() {
        tableView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.separatorStyle = .singleLine
            $0.separatorInset = .zero
            $0.allowsMultipleSelectionDuringEditing = false
            $0.register(DiaryTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
        initNavigationView()
        initTableView()
        initView()
    }
    
    // MARK: - Events
    
    @objc
    private func didTapClose(sender: AnyObject?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func didTapCalendar(sender: AnyObject?) {
        // FIXME: - 캘린더 화면으로 전환
//        self.dismiss(animated: true, completion: nil)
        let viewController = DiaryCalendarViewController()
        viewController.do {
            $0.modalPresentationStyle = .fullScreen
            self.present($0, animated: true, completion: nil)
        }
    }
}

// MARK: - UITableViewDataSource

extension DiaryListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("[caution]: numberOfSections \(monthlyDiary.count)")
        return monthlyDiary.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthlyDiary[section].diary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let diaryData = monthlyDiary[indexPath.section].diary[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? DiaryTableViewCell else {
            return UITableViewCell()
        }
        cell.bind(diary: diaryData)
        return cell
    }

}

// MARK: - UITableViewDelegate

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = DiaryTableHeaderView(title: monthlyDiary[section].month)
        headerView.frame.size.height = 52
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // TODO: Detail 페이지로 이동
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var selectedMonthDiary = monthlyDiary[indexPath.section].diary
            selectedMonthDiary.remove(at: indexPath.row)
            if selectedMonthDiary.isEmpty {
                monthlyDiary.remove(at: indexPath.section)
                tableView.deleteSections([indexPath.section], with: .automatic)
            } else {
                monthlyDiary[indexPath.section].diary = selectedMonthDiary
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }

}
