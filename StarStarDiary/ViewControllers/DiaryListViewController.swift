//
//  DiaryListViewController.swift
//  StarStarDiary
//
//  Created by suhyun on 2019/12/22.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit
import SnapKit

// FIXME: mock up data
fileprivate struct Mockup {
    var title: String
    var date: String
}

final class DiaryListViewController: UIViewController {
    
    private var navigationView = BaseNavigationView(frame: .zero)
    private var tableView = UITableView(frame: .zero)
    
    // MARK: - Vars
    
    // FIXME: mock up data
    private var items: [Mockup] = []
    
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
            $0.setTitle(title: "일기장", titleColor: .black, image: nil)
            $0.setBackgroundColor(color: .white)
            
            let leftTargetType: AddTargetType = (self,
                                                 #selector(didTapClose(sender:)),
                                                 .touchUpInside)
            $0.setBtnLeft(image: UIImage(named: "icClose24"), addTargetType: leftTargetType)
            
            let rightTargetType: AddTargetType = (self,
                                                  #selector(didTapCalendar(sender:)),
                                                  .touchUpInside)
            $0.setBtnRight(image: UIImage(named: "icCalendar24"), addTargetType: rightTargetType)
        }
        
    }
    
    private func initView() {
        view.backgroundColor = .white
    }
    
    private func initVar() {
        // FIXME: 서버에서 가져온 데이터로
        for index in 0..<9 {
            items.append(Mockup(title: "Title \(index)", date: "12월 1일"))
        }
    }
    
    private func initTableView() {
        tableView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.backgroundColor = .white
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
        initNavigationView()
        initTableView()
        initView()
        initVar()
    }
    
    // MARK: - Events
    
    @objc
    private func didTapClose(sender: AnyObject?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func didTapCalendar(sender: AnyObject?) {
        // FIXME: - 캘린더 화면으로 전환
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension DiaryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // FIXME: BaseTalbeViewCell 쓸거임!
        let cell = UITableViewCell()
        cell.textLabel?.text = items[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // TODO: Detail 페이지로 이동
    }
    
    
}
