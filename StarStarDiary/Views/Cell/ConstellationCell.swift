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
    let titleLabel = UILabel()
    let dataLabel = UILabel()
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
    
//    // MARK: - Configure
//
//    func configure(_ constellation: Constellation) {
//
//    }
}

// MARK: - Layouts

extension ConstellationCell {
    func setUpLayout() {}
}

// MARK: - Attributes

extension ConstellationCell {
    func setUpAttribute() {}
}

// MARK: - Reusable

extension ConstellationCell: Reusable {}


