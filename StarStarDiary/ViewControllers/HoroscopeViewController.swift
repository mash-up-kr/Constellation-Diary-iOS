//
//  FortuneView.swift
//  StarStarDiary
//
//  Created by 이동영 on 2019/11/23.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit
import SnapKit
import Then

final class HoroscopeViewController: UIViewController {
    
    // MARK: - UI
    
    private let drawerHandleView = UIView()
    private let titleLabel = UILabel()
    private let suggestionLabel = UILabel()
    private let fortuneItemsView = UIStackView()
    private let seperatorView = UIView()
    private let detailLabel = UILabel()
    private let completeButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpAttributes()
        setUpConstraints()
    }
    
    // MARK: - Configure
    
}
// MARK: - Layout & Attributes

extension HoroscopeViewController {
    
    private func setUpAttributes() {
        view.do {
            $0.backgroundColor = .white
            $0.addSubview(drawerHandleView)
            $0.addSubview(titleLabel)
            $0.addSubview(suggestionLabel)
            $0.addSubview(fortuneItemsView)
            $0.addSubview(seperatorView)
            $0.addSubview(detailLabel)
            $0.addSubview(completeButton)
        }
        
        drawerHandleView.do {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 1.5
        }
        
        titleLabel.do {
            $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            $0.textColor = .black
            // FIXME: - 실제 데이터 모델과 바인드
            $0.text = "별자리 운세"
        }
        
        suggestionLabel.do {
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.textColor = .gray122
            // FIXME: - 실제 데이터 모델과 바인드
            $0.text = "행운의 소품을 확인하세요."
        }
        
        fortuneItemsView.do {
            $0.backgroundColor = .black
        }
        
        seperatorView.do {
            $0.backgroundColor = .white216
        }
        
        detailLabel.do {
            $0.numberOfLines = 0
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.textColor = .black
            // FIXME: - 실제 데이터 모델과 바인드
            $0.text = """
            활기찬 한 주가 되겠네요. 한 주를 시작하는 월요일부터 기운이 넘치는 주간입니다. 유난히 친구를 많이 만나게 됩니다.
            
            즐거운 시간이 많겠지만 건강관리는 좀 하셔야 합니다. 특정한 목적을 가진 만남은 좋지 않습니다. 취미나 동호회활동은 약간 기대에 모자란 정도입니다.
            """
        }
        
        completeButton.do {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 10
        }
    }
    
    private func setUpConstraints() {
        drawerHandleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.width.equalTo(24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(3)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(43)
            $0.centerX.equalToSuperview()
        }
        
        suggestionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        fortuneItemsView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(suggestionLabel.snp.bottom).offset(32)
            $0.width.equalToSuperview().dividedBy(2)
            $0.height.equalTo(70)
        }
        
        seperatorView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.top.equalTo(fortuneItemsView.snp.bottom).offset(24)
            $0.height.equalTo(1)
        }
        
        detailLabel.snp.makeConstraints {
            $0.top.equalTo(seperatorView.snp.bottom).offset(52)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        
        completeButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(50)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(56)
        }
    }
}
