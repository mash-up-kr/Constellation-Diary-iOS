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

class HoroscopeView: UIView {
    
    // MARK: - UI
    private let titleLabel = UILabel()
    private let suggestionLabel = UILabel()
    private let fortuneItemsView = UIStackView()
    
    // MARK: - Methods
    override func draw(_ rect: CGRect) {
        setUpAttributes()
        setUpConstraints()
    }
    
    // MARK: - Configure
    
}
// MARK: - Layout & Attributes
extension HoroscopeView {
    
    private func setUpAttributes() {
        
        self.do {
            $0.addSubview(titleLabel)
            $0.addSubview(suggestionLabel)
            $0.addSubview(fortuneItemsView)
        }
        
        titleLabel.do {
            $0.font.withSize(40)
            $0.textColor = .black
            $0.text = "별자리 운세"
        }
        
        suggestionLabel.do {
            $0.textColor = .gray122
            $0.text = "행운의 소품을 확인하세요."
        }
        fortuneItemsView.do {
            $0.backgroundColor = .black
        }
    }
    
    private func setUpConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(43)
            make.centerX.equalToSuperview()
        }
        
        suggestionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        fortuneItemsView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(suggestionLabel.snp.bottom).offset(32)
            make.width.equalToSuperview().inset(90)
            make.height.equalTo(70)
        }
    }
}
