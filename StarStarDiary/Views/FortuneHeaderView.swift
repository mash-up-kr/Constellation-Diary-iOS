//
//  HoroscopeHeaderView.swift
//  StarStarDiary
//
//  Created by juhee on 2020/01/25.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit


final class HoroscopeHeaderView: UIView {
    
    static let height: CGFloat = 195
    
    var isDrawerHidden: Bool = false {
        didSet {
            self.drawerHandleView.isHidden = self.isDrawerHidden
        }
    }

    private let drawerHandleView = UIView()
    private let titleLabel = UILabel()
    private let suggestionLabel = UILabel()
    private let horoscopeItemsView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpAttributes()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setUpAttributes()
        setUpConstraints()
    }
    
    func bind(horoscope: HoroscopeDto) {
        horoscopeItemsView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        horoscope.items.forEach {
            let itemView = HoroscopeItemView()
            itemView.bind(item: $0)
            horoscopeItemsView.addArrangedSubview(itemView)
        }
        titleLabel.text = "\(horoscope.constellation) 운세"
    }
    
    private func setUpAttributes() {
        self.do {
            $0.backgroundColor = .white
            $0.addSubview(drawerHandleView)
            $0.addSubview(titleLabel)
            $0.addSubview(suggestionLabel)
            $0.addSubview(horoscopeItemsView)
        }
        
        drawerHandleView.do {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 1.5
        }
        
        titleLabel.do {
            $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            $0.textColor = .black
        }
        
        suggestionLabel.do {
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.textColor = .gray122
            $0.text = "오늘의 행운 키워드를 확인하세요."
        }
        
        horoscopeItemsView.do {
            $0.backgroundColor = .black
            $0.spacing = 4
            $0.distribution = .fillEqually
            $0.alignment = .center
            $0.axis = .horizontal
        }
    }
    
    private func setUpConstraints() {
        drawerHandleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.width.equalTo(24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(3)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(drawerHandleView.snp.bottom).offset(16)
            $0.height.greaterThanOrEqualTo(29)
            $0.centerX.equalToSuperview()
        }
        
        suggestionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(1)
            $0.centerX.equalToSuperview()
        }
        
        horoscopeItemsView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(suggestionLabel.snp.bottom).offset(16)
            $0.height.equalTo(70)
            $0.bottom.equalToSuperview()
        }
    }

}
