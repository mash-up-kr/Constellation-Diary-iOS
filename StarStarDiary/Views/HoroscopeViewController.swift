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

class HoroscopeViewController: UIViewController {
    
    // MARK: - UI
    private let titleLabel = UILabel()
    private let suggestionLabel = UILabel()
    private let fortuneItemsView = UIStackView()
    private let seperatorView = UIView()
    private let detailLabel = UILabel()
    private let completeButton = UIButton()
    
    // MARK: - Methods
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
            $0.addSubview(titleLabel)
            $0.addSubview(suggestionLabel)
            $0.addSubview(fortuneItemsView)
            $0.addSubview(seperatorView)
            $0.addSubview(detailLabel)
            $0.addSubview(completeButton)
        }
        
        titleLabel.do {
            $0.font.withSize(40)
            $0.textColor = .black
            $0.text = "별자리 운세"
            $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        }
        
        suggestionLabel.do {
            $0.textColor = .gray122
            $0.text = "행운의 소품을 확인하세요."
            $0.font = UIFont.systemFont(ofSize: 14)
        }
        
        fortuneItemsView.do {
            $0.backgroundColor = .black
        }
        
        detailLabel.do {
            $0.numberOfLines = 0
            $0.textColor = .black
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
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(43)
            make.centerX.equalToSuperview()
        }
        
        suggestionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        fortuneItemsView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(suggestionLabel.snp.bottom).offset(32)
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(70)
        }
        
        seperatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(fortuneItemsView.snp.bottom).offset(24)
            make.height.equalTo(1)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(seperatorView.snp.bottom).offset(52)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        completeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
        }
    }
}
