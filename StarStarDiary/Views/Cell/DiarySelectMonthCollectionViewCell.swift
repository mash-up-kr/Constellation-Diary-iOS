//
//  DiarySelectMonthCollectionViewCell.swift
//  StarStarDiary
//
//  Created by suhyun on 2020/03/16.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit

extension DiarySelectMonthCollectionViewCell: Reusable {}
final class DiarySelectMonthCollectionViewCell: UICollectionViewCell {
    
    private let baseView = UIView(frame: .zero)
    private let stackView = UIStackView(frame: .zero)
    private let monthLabel = UILabel(frame: .zero)
    private let numOfDiaryLabel = UILabel(frame: .zero)
    
    // MARK: - Bind
    
    func bind(title: String, value: String, isSelected: Bool) {
        self.monthLabel.text = title
        self.numOfDiaryLabel.text = value
        
        if isSelected {
            baseView.backgroundColor = .navy3
            monthLabel.textColor = .white
            numOfDiaryLabel.textColor = .white
        } else {
            baseView.backgroundColor = .clear
            monthLabel.textColor = .black
            numOfDiaryLabel.textColor = .gray122
        }
    }
    
    // MARK: - Setup
    
    private func setupBaseView() {
        baseView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        baseView.do {
            $0.layer.cornerRadius = 3.0
            $0.clipsToBounds = true
        }
    }
    
    private func setupStackView() {
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        stackView.do {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.spacing = 4.0
            $0.isUserInteractionEnabled = true
        }
    }
    
    private func setupLabels() {
        
        monthLabel.do {
            $0.textAlignment = .right
            $0.font = UIFont.systemFont(ofSize: 12.0)
        }
        
        numOfDiaryLabel.do {
            $0.textAlignment = .left
            $0.font = UIFont.systemFont(ofSize: 10.0)
        }
    }
    
    // MARK: - Init
    
    private func initLayout() {
        addSubview(baseView)
        baseView.addSubview(stackView)
        stackView.addArrangedSubview(monthLabel)
        stackView.addArrangedSubview(numOfDiaryLabel)

        setupBaseView()
        setupStackView()
        setupLabels()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initLayout()

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initLayout()
    }
}

extension DiarySelectMonthCollectionViewHeaderView: Reusable {}
final class DiarySelectMonthCollectionViewHeaderView: UICollectionReusableView {
    
    private let titleLabel = UILabel(frame: .zero)
    
    // MARK: - Bind
    
    func bind(title: String) {
        titleLabel.text = title
    }
    
    // MARK: - Setup
    
    private func setupLabels() {
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        titleLabel.do {
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        }
    }
    
    // MARK: - Init
    
    private func initLayout() {
        addSubview(titleLabel)
        
        setupLabels()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initLayout()
    }
}
