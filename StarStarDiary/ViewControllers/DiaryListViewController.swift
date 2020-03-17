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
    private let navigationBottomLineView = UIView(frame: .zero)

    private let titleView = UIView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let titleButton = UIButton(frame: .zero)
    private let titleBottomLineView = UIView(frame: .zero)
    
    private let tableView = UITableView(frame: .zero)
    
    private let reuseIdentifier: String = "diary_cell"
    
    // MARK: - Vars
    
    private var currentDate = Date()
    private var items: [SimpleDiaryDto] = [] // all of month

    // MARK: - Init
    
    private func initLayout() {
        view.addSubview(navigationView)
        view.addSubview(navigationBottomLineView)

        view.addSubview(titleView)
        titleView.addSubview(titleLabel)
        titleView.addSubview(titleButton)
        titleView.addSubview(titleBottomLineView)
        
        view.addSubview(tableView)

        //
        navigationView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44.0)
        }
        
        navigationBottomLineView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(1.0)
        }
        
        //
        titleView.snp.makeConstraints {
            $0.top.equalTo(navigationBottomLineView.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(48.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        titleButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.width.equalTo(titleLabel.snp.height)
        }
        
        titleBottomLineView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(1.0)
        }

        //
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(titleBottomLineView.snp.bottom)
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
        
        navigationBottomLineView.do {
            $0.backgroundColor = UIColor.white216
        }
    }
    
    private func initView() {
        view.backgroundColor = .white
        
        titleLabel.do {
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 18.0)
            $0.textColor = .black
        }
        
        titleBottomLineView.do {
            $0.backgroundColor = UIColor.white216
        }
        
        titleButton.do {
            $0.setImage(UIImage(named: "icDown24"), for: .normal)
            $0.addTarget(self, action: #selector(didClickedSelectionMonth(sender:)), for: .touchUpInside)
        }
        
        titleLabel.do {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didClickedSelectionMonth(sender:)))
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(tapGesture)
        }
    }
    
    private func initTableView() {
        tableView.do {
            $0.backgroundColor = .clear
            $0.dataSource = self
            $0.delegate = self
            $0.separatorStyle = .singleLine
            $0.separatorInset = .zero
            $0.allowsMultipleSelectionDuringEditing = false
            $0.register(DiaryTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
            $0.tableFooterView = UIView()
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
        initNavigationView()
        initTableView()
        initView()
        
        changeCurrentMonth(date: currentDate)
    }
    
    // MARK: - APIs
    
    func getDiariesOfMonth(date: Date, completion: @escaping ([SimpleDiaryDto]?) -> Void) {
        let cal = Calendar.current
        let year = cal.component(.year, from: date)
        let month = cal.component(.month, from: date)
        
        Provider.request(DiaryAPI.diaries(month: month, year: year), completion: { (diaries: DiariesDto) in
            completion(diaries.diaries)
        }) { error in
            print(error)
            completion(nil)
        }
    }
    
    // MARK: -
    
    private func changeCurrentMonth(date: Date) {
        currentDate = date
        
        titleLabel.do {
            let dateFormatter = DateFormatter.defaultInstance
            dateFormatter.dateFormat = "YYYY년 MM월"
            
            $0.text = dateFormatter.string(from: date)
        }
        
        getDiariesOfMonth(date: date) { [weak self] diraiesOfMonth in
            guard let self = self else { return }
            self.items = diraiesOfMonth ?? []

            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Events
    
    @objc
    private func didTapClose(sender: AnyObject?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func didTapCalendar(sender: AnyObject?) {
        let viewController = DiaryCalendarViewController()
        viewController.do {
            $0.modalPresentationStyle = .fullScreen
            self.present($0, animated: true, completion: nil)
        }
    }
    
    @objc
    private func didClickedSelectionMonth(sender: AnyObject?) {
        // FIXME: Date() 변경 -> 현재 보고 있는 월로
        let viewController = DiarySelectMonthViewController(current: Date(), delegate: self)
        viewController.do {
            $0.modalPresentationStyle = .overFullScreen
            self.present($0, animated: false, completion: nil)
        }
    }
}

// MARK: - UITableViewDataSource

extension DiaryListViewController: UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        print("[caution]: numberOfSections \(monthlyDiary.count)")
//        return monthlyDiary.count
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? DiaryTableViewCell else {
            return UITableViewCell()
        }
        cell.bind(diary: items[indexPath.row])
        return cell
    }

}

// MARK: - UITableViewDelegate

extension DiaryListViewController: UITableViewDelegate {
    // MARK: - Karen.
    // 디자인 변경으로 인한 header 불필요 부분 주석
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = DiaryTableHeaderView(title: monthlyDiary[section].month)
//        headerView.frame.size.height = 52
//        return headerView
//    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 52
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return nil
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // TODO: Detail 페이지로 이동
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            var selectedMonthDiary = monthlyDiary[indexPath.section].diary
//            selectedMonthDiary.remove(at: indexPath.row)
//            if selectedMonthDiary.isEmpty {
//                monthlyDiary.remove(at: indexPath.section)
//                tableView.deleteSections([indexPath.section], with: .automatic)
//            } else {
//                monthlyDiary[indexPath.section].diary = selectedMonthDiary
//                tableView.deleteRows(at: [indexPath], with: .automatic)
//            }
//        }
    }

}

// MARK: - DiraySelectMonthViewDelegate

extension DiaryListViewController: DiraySelectMonthViewDelegate {
    func didSelectedMonth(viewController: DiarySelectMonthViewController, month: Int, year: Int) {
        print(#function)
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateformatter.date(from: String(format: "%d-%02d-15 00:00:00", year, month)) {
            changeCurrentMonth(date: date)
        }
    }
}
