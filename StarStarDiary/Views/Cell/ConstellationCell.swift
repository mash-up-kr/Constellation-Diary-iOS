//
//  ConstellationCell.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/01/12.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit

class ConstellationCell: UICollectionViewCell {
    
    // MARK: - UI
    
    let iconImageView = UIImageView()
    let nameLabel = UILabel()
    let dateLabel = UILabel()
    let imageView = UIImageView()
    
    // MARK: - Initalization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpLayout()
        setUpAttribute()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUpLayout()
        setUpAttribute()
    }
    
    // MARK: - Configure
    
    func configure(_ constellation: Constellation) {
        // TODO: image 추후 구성
        nameLabel.text = constellation.name
        dateLabel.text = constellation.date
    }
}

// MARK: - Layouts

extension ConstellationCell {
    func setUpLayout() {
        
        contentView.do {
            $0.addSubview(iconImageView)
            $0.addSubview(nameLabel)
            $0.addSubview(dateLabel)
            $0.addSubview(imageView)
        }
        
        iconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(contentView.bounds.height * 1.0/20.0)
            $0.leading.trailing.equalToSuperview().inset(contentView.bounds.width * 5.0/12.0)
            $0.height.equalTo(iconImageView.snp.width)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(contentView.bounds.height * 1.0/100.0)
            $0.leading.trailing.equalToSuperview().inset(contentView.bounds.width * 1.0/30.0)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(contentView.bounds.width * 1.0/30.0)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(contentView.bounds.height * 16.0/170.0)
            $0.leading.trailing.equalToSuperview().inset(contentView.bounds.width * 13.0/226.0)
            $0.height.equalTo(imageView.snp.width)
        }
    }
}

// MARK: - Attributes

extension ConstellationCell {
    func setUpAttribute() {
        contentView.do {
            $0.layer.cornerRadius = 5
            $0.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.14)
        }
        
        iconImageView.do {
            // FIXME: 추후 수정
            $0.backgroundColor = .gray
        }
        
        nameLabel.do {
            // FIXME: 추후 수정
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = .white
            $0.textAlignment = .center
        }
        
        dateLabel.do {
            // FIXME: 추후 수정
            $0.font = .systemFont(ofSize: 12)
            $0.textColor = .white
            $0.textAlignment = .center
        }
        
        imageView.do {
            // FIXME: 추후 수정
            $0.backgroundColor = .gray
        }
    }
}

// MARK: - Reusable

extension ConstellationCell: Reusable {}


