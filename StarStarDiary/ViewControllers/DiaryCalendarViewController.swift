//
//  DiaryCalendarViewController.swift
//  StarStarDiary
//
//  Created by suhyun on 2020/02/08.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit
import FSCalendar

protocol DiaryCalendarViewDelegate: class {
    func didDeleteDiary(viewController: DiaryCalendarViewController)
}

final class DiaryCalendarViewController: UIViewController {
    
    private let navigationView = BaseNavigationView(frame: .zero)
    private let navigationBottomLineView = UIView(frame: .zero)
    
    private let titleView = UIView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let titleButton = UIButton(frame: .zero)
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

    private var monthlyItems: [SimpleDiaryDto] = [] // all of month
    private var items: [SimpleDiaryDto] = [] // all of day
    
    private weak var delegate: DiaryCalendarViewDelegate?
    private var selectedDate = Date()
    
    // MARK: - Init
    
    convenience init(delegate: DiaryCalendarViewDelegate?) {
        self.init()
        
        self.delegate = delegate
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
        
        setCalendar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeCurrentPage(currentDate: calendar.currentPage)
    }
    
}

// MARK: - FSCalendarDelegate, FSCalendarDataSource

extension DiaryCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print(calendar.currentPage)

        changeCurrentPage(currentDate: calendar.currentPage)
        
        getDiariesOfMonth(date: calendar.currentPage) { [weak self] diraiesOfMonth in
            guard let self = self else { return }
            self.monthlyItems = diraiesOfMonth ?? []
            self.calendar.reloadData()
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
        
        selectedDate = date
        refreshDiaryList(currentDay: selectedDate)
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        
        if monthlyItems.contains(where: { (diary) -> Bool in
            let cal = Calendar.current
            let dMonth = cal.component(.month, from: diary.date)
            let dDay = cal.component(.day, from: diary.date)
            
            let month = cal.component(.month, from: date)
            let day = cal.component(.day, from: date)
            
            if (dMonth == month) && (dDay == day) {
                return true
            } else {
                return false
            }
        }) {
            return UIImage(named: "icStar24")
        } else {
            return nil
        }
    }
        
}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension DiaryCalendarViewController: UITableViewDelegate, UITableViewDataSource {

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.items[indexPath.row]
        Provider.request(DiaryAPI.diary(id: item.id), completion: { (diary: DiaryDto) in
            let writeViewController = WriteViewController()
            writeViewController.bind(diary: diary, isEditable: item.date.isSameDate(with: Date()))
            self.navigationController?.pushViewController(writeViewController, animated: true)
        })
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        if editingStyle == .delete {
            deleteDiary(item: item)
        }
    }
}

// MARK: - DiarySelectMonthViewDelegate

extension DiaryCalendarViewController: DiarySelectMonthViewDelegate {
    func didSelectedMonth(viewController: DiarySelectMonthViewController, month: Int, year: Int) {
        print(#function)

        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateformatter.date(from: String(format: "%d-%02d-15 00:00:00", year, month)) {
            calendar.setCurrentPage(date, animated: true)
        }
        
    }
}

private extension DiaryCalendarViewController {
    
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
    
    func deleteDiary(item: SimpleDiaryDto) {
        Provider.request(.deleteDiary(id: item.id), completion: { [weak self] isSuccess in
            guard let self = self else { return }
            if isSuccess {
                
                self.delegate?.didDeleteDiary(viewController: self)
                
                self.getDiariesOfMonth(date: self.selectedDate) { [weak self] diraiesOfMonth in
                    guard let self = self else { return }
                    self.monthlyItems = diraiesOfMonth ?? []
                    
                    self.refreshDiaryList(currentDay: self.selectedDate)
                }
                NotificationCenter.default.post(name: .didDeleteDiaryNotification, object: nil, userInfo: [NotificationInfoKey.deletedDiaryIDKey: item.id])
            } else {
                // TODO: error 문구 처리
            }
        }) { errorData in
            print(errorData)
            // TODO: error 문구 처리
        }
    }
    
    // MARK: - Refresh UI
    
    func refreshDiaryList(currentDay: Date) {
        items = monthlyItems.filter({ (diary) -> Bool in
            let cal = Calendar.current
            let currentDay = cal.component(.day, from: currentDay)
            let diaryDay = cal.component(.day, from: diary.date)

            return currentDay == diaryDay ? true : false
        })
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Events
        
    @objc
    func didTapClose(sender: AnyObject?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func didTapList(sender: AnyObject?) {
        self.navigationController?.popViewController(animated: false)
    }

    @objc
    func didClickedTodayButton(sender: AnyObject?) {
        let current = Date()
        calendar.setCurrentPage(current, animated: true)
        getDiariesOfMonth(date: current) { [weak self] diraiesOfMonth in
            guard let self = self else { return }
            self.monthlyItems = diraiesOfMonth ?? []
            
            self.calendar.select(current, scrollToDate: true)
            self.refreshDiaryList(currentDay: current) // 현재 날짜에 작성된 list
        }
    }
    
    @objc
    func didClickedSelectionMonth(sender: AnyObject?) {
        let viewController = DiarySelectMonthViewController(current: calendar.currentPage, delegate: self)
        viewController.do {
            $0.modalPresentationStyle = .overFullScreen
            self.present($0, animated: false, completion: nil)
        }
    }
    
    func changeCurrentPage(currentDate: Date?) {
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
    
    func initLayout() {
        view.addSubview(navigationView)
        view.addSubview(navigationBottomLineView)
        
        view.addSubview(titleView)
        titleView.addSubview(titleLabel)
        titleView.addSubview(titleButton)
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
            $0.centerX.equalToSuperview()
        }
        
        titleButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.width.equalTo(titleLabel.snp.height)
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
    
    func initView() {
        view.backgroundColor = .white
        titleLabel.sizeToFit()
    }
    
    func initNavigationView() {
        navigationView.do {
            $0.setTitle(title: "일기장", titleColor: .black)
            $0.setBackgroundColor(color: .white)
            
            let leftTargetType: AddTargetType = (self,
                                                 #selector(didTapClose(sender:)),
                                                 .touchUpInside)
            $0.setButton(type: .left, image: UIImage(named: "icClose24"), addTargetType: leftTargetType)
            
            let rightTargetType: AddTargetType = (self,
                                                  #selector(didTapList(sender:)),
                                                  .touchUpInside)
            $0.setButton(type: .right, image: UIImage(named: "icList24"), addTargetType: rightTargetType)
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
    
    func initCalendar() {
        calendar.do {
            $0.headerHeight = 0.0
            $0.delegate = self
            $0.dataSource = self
            $0.appearance.todayColor = .clear
            $0.appearance.titleTodayColor = .black
            $0.appearance.selectionColor = .gray197
            $0.appearance.titleSelectionColor = .black
            
            let weekday = ["일", "월", "화", "수", "목", "금", "토"]
            for (index, weekdayLabel) in $0.appearance.calendar.calendarWeekdayView.weekdayLabels.enumerated() {
                weekdayLabel.text = weekday[index]
                weekdayLabel.textColor = (index == 0) ? .systemRed : UIColor.gray153
            }
        }
    }
    
    func initButton() {
        todayButton.do {
            $0.addTarget(self, action: #selector(didClickedTodayButton(sender:)), for: .touchUpInside)
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
    
    func initTableView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.separatorStyle = .singleLine
            $0.separatorInset = .zero
            $0.allowsMultipleSelectionDuringEditing = false
            $0.register(DiaryTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
            $0.tableFooterView = UIView()
        }
    }
    
    func setCalendar() {
        calendar.select(Date())
        
        getDiariesOfMonth(date: calendar.currentPage) { [weak self] diraiesOfMonth in
            guard let self = self else { return }
            self.monthlyItems = diraiesOfMonth ?? []
            
            self.refreshDiaryList(currentDay: Date()) // 현재 날짜에 작성된 list
            self.calendar.reloadData()
        }
    }

}
