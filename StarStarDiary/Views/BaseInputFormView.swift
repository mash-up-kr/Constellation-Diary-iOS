//
//  InputCell.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/01/15.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit
import SnapKit
import Then

class BaseInputFormView: UIView {
    
    let titleLabel = UILabel()
    let inputTextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        setupAttribute()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupLayout()
        setupAttribute()
    }
    
    // MARK: - Layouts
    
    private func setupLayout() {
        self.do {
            $0.addSubview(titleLabel)
            $0.addSubview(inputTextField)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().offset(self.bounds.width * 5.3/100.0)
        }
        
        inputTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalTo(titleLabel)
        }
    }
    
    // MARK: - Attributes
    
    private func setupAttribute() {
        titleLabel.do {
            $0.font = .systemFont(ofSize: 12)
            $0.textColor = .black
        }
        
        inputTextField.do {
            $0.font = .systemFont(ofSize: 18)
            $0.textColor = .black
            // TODO: - underline이 있는 feature가 병합되면 추가할 예정
        }
    }
}
