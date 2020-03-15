//
//  DiaryTableViewCell.swift
//  StarStarDiary
//
//  Created by juhee on 2019/12/31.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit
import SnapKit
import Then

final class DiaryTableViewCell: UITableViewCell {
    
    private let dateLabel: UILabel = UILabel(frame: .zero)
    private let dayLabel: UILabel = UILabel(frame: .zero)
    private let timeLabel: UILabel = UILabel(frame: .zero)
    private let titleLabel: UILabel = UILabel(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func bind(diary: Diary) {
        let dateFormatter = DateFormatter.defaultInstance
        dateFormatter.locale = Locale.init(identifier: "ko")
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        
        dateFormatter.dateFormat = "a HH:MM"
        timeLabel.text = dateFormatter.string(from: diary.date)
        
        dateFormatter.dateFormat = "E"
        dayLabel.text = dateFormatter.string(from: diary.date)
        
        dateFormatter.dateFormat = "dd"
        dateLabel.text = dateFormatter.string(from: diary.date)
        
        titleLabel.text = diary.title
        
        let dateTextColor: UIColor = diary.date.isSunDay ? .red : .black
        dayLabel.textColor = dateTextColor
        dateLabel.textColor = dateTextColor
    }
    
    // MARK: - Karen.
    // bind(diary: Diary) 와 동일한 기능을 하는 함수.
    // Diary 구조체는 sample로 존재했던 것으로, 우선 서버 데이터를 받아온 구조체를 위한 bind 함수 구현.
    func bind(diary: SimpleDiaryDto) {
        let dateFormatter = DateFormatter.defaultInstance
        dateFormatter.locale = Locale.init(identifier: "ko")
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        
        dateFormatter.dateFormat = "a HH:MM"
        timeLabel.text = dateFormatter.string(from: diary.date)
        
        dateFormatter.dateFormat = "E"
        dayLabel.text = dateFormatter.string(from: diary.date)
        
        dateFormatter.dateFormat = "dd"
        dateLabel.text = dateFormatter.string(from: diary.date)
        
        titleLabel.text = diary.title
        
        let dateTextColor: UIColor = diary.date.isSunDay ? .red : .black
        dayLabel.textColor = dateTextColor
        dateLabel.textColor = dateTextColor
    }
    
    private func setup() {
        addSubview(dateLabel)
        addSubview(dayLabel)
        addSubview(titleLabel)
        addSubview(timeLabel)
        setupDateLabel()
        setupDayLabel()
        setupTitleLabel()
        setupTimeLabel()
    }
    
    private func setupDateLabel() {
        dateLabel.font = .systemFont(ofSize: 24, weight: .medium)
        dateLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.snp.leading).inset(33)
            $0.top.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }

    private func setupDayLabel() {
        dayLabel.font = .systemFont(ofSize: 14, weight: .regular)
        dayLabel.textColor = UIColor.gray122
        dayLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(50)
            $0.centerY.equalTo(dateLabel.snp.centerY)
        }
    }

    private func setupTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(86)
            $0.trailing.lessThanOrEqualTo(timeLabel.snp.leading).inset(23)
            $0.centerY.equalTo(dateLabel.snp.centerY)
        }
    }

    private func setupTimeLabel() {
        timeLabel.font = .systemFont(ofSize: 12, weight: .regular)
        timeLabel.textColor = UIColor.gray122
        timeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(dateLabel.snp.centerY)
        }
    }
}
