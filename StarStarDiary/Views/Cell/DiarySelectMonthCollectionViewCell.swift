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
    
    func bind(title: String, value: String) {
        self.monthLabel.text = title
        self.numOfDiaryLabel.text = value
    }
    
    // MARK: - Setup
    
    private func setupBaseView() {
        baseView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupStackView() {
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.backgroundColor = .red // test
            $0.layer.cornerRadius = 4.0
        }
    }
    
    private func setupLabels() {
        monthLabel.do {
            $0.textAlignment = .right
        }
        
        numOfDiaryLabel.do {
            $0.textAlignment = .left
        }
        
//        monthLabel.snp.makeConstraints {
//            $0.top.equalTo(titleLabel.snp.bottom)
//            $0.bottom.equalToSuperview()
//        }
    }
    
    // MARK: - Init
    
    private func initLayout() {
        addSubview(baseView)
        baseView.addSubview(stackView)
        stackView.addArrangedSubview(monthLabel)
        stackView.addArrangedSubview(numOfDiaryLabel)

        setupStackView()
        setupLabels()
        
        monthLabel.text = "1월"
        numOfDiaryLabel.text = "30"
        stackView.backgroundColor = .red
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
