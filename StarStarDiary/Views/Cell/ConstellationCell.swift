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
        self.backgroundColor = .white
        self.contentView.backgroundColor = .yellow
        setUpLayout()
        setUpAttribute()
    }
    
    // MARK: - Configure
    
    func configure(_ constellation: Constellation) {
        nameLabel.text = constellation.name
        dateLabel.text = constellation.date
        imageView.image = constellation.thumnail
        iconImageView.image = constellation.icon
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
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(100)
            $0.height.equalTo(iconImageView.snp.width)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.leading.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(40)
            $0.width.equalTo(200)
            $0.height.equalTo(imageView.snp.width)
            $0.centerX.equalToSuperview()
        }
        
    }
}

// MARK: - Attributes

extension ConstellationCell {
    
    override var isSelected: Bool {
        didSet {
            self.backgroundView?.isHidden = self.isSelected
            self.selectedBackgroundView?.isHidden = !self.isSelected
        }
    }
    func setUpAttribute() {
        nameLabel.do {
            $0.font = .font(.notoSerifCJKMedium, size: 16)
            $0.textColor = .white
            $0.textAlignment = .center
        }
        
        dateLabel.do {
            $0.font = .font(.notoSerifCJKMedium, size: 12)
            $0.textColor = UIColor(white: 1, alpha: 0.65)
            $0.textAlignment = .center
        }
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.init(white: 1, alpha: 0.14)
        self.backgroundView = backgroundView

        let shadowBackgroundView = UIView()
        shadowBackgroundView.backgroundColor = .clear
        shadowBackgroundView.layer.borderColor = UIColor.white.cgColor
        shadowBackgroundView.layer.borderWidth = 1
        shadowBackgroundView.layer.shadowColor = UIColor.white.cgColor
        shadowBackgroundView.layer.shadowRadius = 8
        shadowBackgroundView.layer.shadowOpacity = 1
        shadowBackgroundView.layer.shadowOffset = .zero
        shadowBackgroundView.layer.cornerRadius = 5

        selectedBackgroundView = shadowBackgroundView

    }
}

// MARK: - Reusable

extension ConstellationCell: Reusable {}
