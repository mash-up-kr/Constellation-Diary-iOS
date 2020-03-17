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
    
    // 작성된 운세가 없을 때 보여지는 뷰
    private let noneView = UIView(frame: .zero)
    private let noneContentsView = UIView(frame: .zero)
    private let noneImageView = UIImageView(frame: .zero)
    private let noneLabel = UILabel(frame: .zero)
    private let noneBottomView = UIView(frame: .zero)
    private let writeButton = UIButton(frame: .zero)
    private let showFortuneButton = UIButton(frame: .zero)
    
    // MARK: - Vars
    
    private let reuseIdentifier: String = "diary_cell"
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
        
        view.addSubview(noneView)
        noneView.addSubview(noneContentsView)
        noneContentsView.addSubview(noneImageView)
        noneContentsView.addSubview(noneLabel)
        noneView.addSubview(noneBottomView)
        noneBottomView.addSubview(writeButton)
        noneBottomView.addSubview(showFortuneButton)

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
        
        //
        noneView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(titleBottomLineView.snp.bottom)
        }
        
        noneContentsView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(noneBottomView.snp.top)
        }
        
        noneBottomView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.3)
        }
        
        writeButton.snp.makeConstraints {
            $0.height.equalTo(56.0)
            $0.leading.trailing.equalToSuperview().inset(24.0)
            $0.bottom.equalToSuperview().inset(16.0)
        }
        
        showFortuneButton.snp.makeConstraints {
            $0.height.equalTo(56.0)
            $0.leading.trailing.equalToSuperview().inset(24.0)
            $0.bottom.equalTo(writeButton.snp.top).offset(-16.0)
        }
        
        noneImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.9)
            $0.width.equalTo(136.0)
            $0.height.equalTo(noneImageView.snp.width).multipliedBy(1.2)
        }
        
        noneLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.top.equalTo(noneImageView.snp.bottom).offset(24.0)
        }
                
    }
    
    private func initNavigationView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
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
        
        noneView.isHidden = true
        noneImageView.do {
            $0.image = UIImage(named: "illustTree")
            $0.contentMode = .scaleAspectFit
        }
        
        noneLabel.do {
            $0.text = "작성된 일기가 없어요.\n오늘의 운세를 확인하고 일기장을 채워주세요."
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 16.0)
            $0.textColor = .navy118
            $0.numberOfLines = 0
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
    
    private func initButton() {
        writeButton.do {
            $0.layer.cornerRadius = 8.0
            $0.backgroundColor = .navy3
            $0.titleLabel?.textColor = .white
            $0.setTitle("일기 작성하기", for: .normal)
            $0.addTarget(self, action: #selector(didClickedWirteDiary(sender:)), for: .touchUpInside)
        }
        
        showFortuneButton.do {
            $0.layer.cornerRadius = 8.0
            $0.backgroundColor = .navy3
            $0.titleLabel?.textColor = .white
            $0.setTitle("별자리 운세보기", for: .normal)
            $0.addTarget(self, action: #selector(didClickedShowForturn(sender:)), for: .touchUpInside)
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
        initNavigationView()
        initTableView()
        initView()
        initButton()
        
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
    
    func deleteDiary(item: SimpleDiaryDto) {
        if let deleteID = item.id {
            Provider.request(.deleteDiary(id: deleteID), completion: { [weak self] isSuccess in
                guard let self = self else { return }
                if isSuccess {
                    self.changeCurrentMonth(date: self.currentDate)
                } else {
                    // TODO: error 문구 처리
                }
            }) { errorData in
                print(errorData)
                // TODO: error 문구 처리
            }
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

            if self.items.isEmpty {
                self.noneView.isHidden = false
            } else {
                self.noneView.isHidden = true
            }
            
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
        let viewController = DiaryCalendarViewController(delegate: self)
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
    
    @objc
    private func didClickedShowForturn(sender: AnyObject?) {
        // TODO: -
        
        let horoscopeViewController = HoroscopeDetailViewController()
//        if let horoscope = self.horoscope {
//            horoscopeViewController.bind(data: horoscope, type: .detail)
            navigationController?.present(horoscopeViewController, animated: true, completion: nil)
//            return
//        }
    }
    
    @objc func didClickedWirteDiary(sender: AnyObject?) {
        // TODO: -

        let diaryViewController = WriteViewController()
//        if let horoscope = self.horoscope {
//            diaryViewController.bind(horoscope: horoscope)
//        }
        self.navigationController?.pushViewController(diaryViewController, animated: true)
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
    // 디자인 변경으로 인한 header 불.필요 부분 주석
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
        let item = items[indexPath.row]
        
        if editingStyle == .delete {
            deleteDiary(item: item)
        }
    }

}

// MARK: - DiraySelectMonthViewDelegate

extension DiaryListViewController: DiarySelectMonthViewDelegate {
    func didSelectedMonth(viewController: DiarySelectMonthViewController, month: Int, year: Int) {
        print(#function)
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateformatter.date(from: String(format: "%d-%02d-15 00:00:00", year, month)) {
            changeCurrentMonth(date: date)
        }
    }
}

// MARK: - DiaryCalendarViewDelegate

extension DiaryListViewController: DiaryCalendarViewDelegate {
    func didDeleteDiary(viewController: DiaryCalendarViewController) {
        changeCurrentMonth(date: currentDate)
    }
}
