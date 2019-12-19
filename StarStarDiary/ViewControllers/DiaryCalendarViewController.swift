//
//  DiaryCalendarViewController.swift
//  StarStarDiary
//
//  Created by suhyun on 2020/02/08.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit
import FSCalendar

class DiaryCalendarViewController: UIViewController {
    
    private let navigationView = BaseNavigationView(frame: .zero)
    private let navigationBottomLineView = UIView(frame: .zero)
    
    private let titleView = UIView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let todayButton = UIButton(frame: .zero)
    private let titleBottomLineView = UIView(frame: .zero)

    private let calendarView = UIView(frame: .zero)
    private let calendarTitleLabel = UILabel(frame: .zero)
    private let calendar = FSCalendar(frame: .zero)
    private let calendarWeekdayBottomLineView = UIView(frame: .zero)
    private let calendarBottomLineView = UIView(frame: .zero)
    
    private let tableView = UITableView(frame: .zero)
    
    // MARK: - Vars
    private let reuseIdentifier: String = "diary_cell"

    // FIXME: mock up data
    private var monthlyDiary = sampleDiary
    
    // MARK: - Init
    
    private func initLayout() {
        view.addSubview(navigationView)
        view.addSubview(navigationBottomLineView)
        
        view.addSubview(titleView)
        titleView.addSubview(titleLabel)
        titleView.addSubview(todayButton)
        titleView.addSubview(titleBottomLineView)
        
        view.addSubview(calendarView)
        calendarView.addSubview(calendarTitleLabel)
        calendarView.addSubview(calendar)
        calendarView.addSubview(calendarWeekdayBottomLineView)
        calendarView.addSubview(calendarBottomLineView)
        
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
            $0.leading.trailing.equalToSuperview()
        }
        
        todayButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.equalTo(56.0)
        }
        
        titleBottomLineView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(1.0)
        }

        //
        calendarView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalToSuperview().multipliedBy(0.47)
        }
        
        calendarTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(24.0)
            $0.leading.equalTo(calendarView).offset(32.0)
            $0.trailing.equalTo(calendarView).inset(32.0)
        }
        
        calendar.snp.makeConstraints {
            $0.top.equalTo(calendarTitleLabel.snp.bottom).offset(16.0)
            $0.leading.equalToSuperview().offset(16.0)
            $0.trailing.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview().inset(16.0)
        }
        
        calendarWeekdayBottomLineView.snp.makeConstraints {
            $0.bottom.equalTo(calendar.calendarWeekdayView.snp.bottom).offset(4.0)
            $0.leading.equalTo(calendar).offset(16.0)
            $0.trailing.equalTo(calendar).inset(16.0)
            $0.height.equalTo(1.0)
        }
        
        calendarBottomLineView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(1.0)
        }

        //
        tableView.snp.makeConstraints {
            $0.top.equalTo(calendarBottomLineView.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func initView() {
        view.backgroundColor = .white
    }
    
    private func initNavigationView() {
        navigationView.do {
            $0.setTitle(title: "일기장", titleColor: .black, image: nil)
            $0.setBackgroundColor(color: .white)
            
            let leftTargetType: AddTargetType = (self,
                                                 #selector(didTapClose(sender:)),
                                                 .touchUpInside)
            $0.setBtnLeft(image: UIImage(named: "icClose24"), addTargetType: leftTargetType)
            
            let rightTargetType: AddTargetType = (self,
                                                  #selector(didTapList(sender:)),
                                                  .touchUpInside)
            $0.setBtnRight(image: UIImage(named: "icList24"), addTargetType: rightTargetType)
        }
        
        navigationBottomLineView.do {
            $0.backgroundColor = UIColor.white216
        }
        
        titleLabel.do {
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 18.0)
            $0.textColor = .black
        }
        
        calendarTitleLabel.do {
            $0.font = .systemFont(ofSize: 16.0)
            $0.textColor = .black
        }
        
        todayButton.do {
            $0.setTitle("오늘", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 14.0)
            $0.setTitleColor(UIColor.blue189, for: .normal)
        }
        
        titleBottomLineView.do {
            $0.backgroundColor = UIColor.white216
        }
        
        calendarWeekdayBottomLineView.do {
            $0.backgroundColor = UIColor.gray243
        }
        
        calendarBottomLineView.do {
            $0.backgroundColor = UIColor.white216
        }
    }
    
    private func initCalendar() {
        calendar.do {
            $0.headerHeight = 0.0
            $0.delegate = self
            $0.dataSource = self
            $0.appearance.todayColor = UIColor.gray197
            $0.appearance.titleTodayColor = .black
        }
    }
    
    private func initButton() {
        todayButton.do {
            $0.addTarget(self, action: #selector(didClickedTodayButton(sender:)), for: .touchUpInside)
        }
    }
    
    private func initTableView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
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
        initView()
        initCalendar()
        initButton()
        initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeCurrentPage(currentDate: calendar.currentPage)
    }
    
    // MARK: - Events
        
    @objc
    private func didTapClose(sender: AnyObject?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func didTapList(sender: AnyObject?) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc
    private func didClickedTodayButton(sender: AnyObject?) {
        print(#function)
    }
    
    private func changeCurrentPage(currentDate: Date?) {
        let currentDate = currentDate ?? Date()
        
        titleLabel.do {
            let dateFormatter = DateFormatter.defaultInstance
            dateFormatter.dateFormat = "YYYY년 MM월"
            
            $0.text = dateFormatter.string(from: currentDate)
        }
        
        calendarTitleLabel.do {
            let dateFormatter = DateFormatter.defaultInstance
            dateFormatter.dateFormat = "MM월"
            
            $0.text = dateFormatter.string(from: currentDate)
        }
    }
}

// MARK: - FSCalendarDelegate, FSCalendarDataSource

extension DiaryCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print(calendar.currentPage)

        changeCurrentPage(currentDate: calendar.currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        return UIImage()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension DiaryCalendarViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // TODO: Detail 페이지로 이동
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
}