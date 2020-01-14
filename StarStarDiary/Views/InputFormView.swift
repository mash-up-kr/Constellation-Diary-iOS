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

class InputFormView: UIView {
    
    // MARK: - UI
    
    let titleLabel = UILabel()
    let inputTextField = UITextField()
    
    var timerLabel: UILabel?
    var actionButton: UIButton?
    var verificationImageView: UIImageView?
    var verificationMessageLabel: UILabel?
    
    // MARK: - Initialization
    
    convenience init(frame: CGRect = .zero, style: Style) {
        self.init(frame: frame)
        
        configure(style: style)
        setupLayout()
        setupAttribute()
    }
    
    // MARK: - Layouts
    
    func setupLayout() {
        self.do {
            $0.addSubview(titleLabel)
            $0.addSubview(inputTextField)
            
            if let timerLabel = timerLabel {
                $0.addSubview(timerLabel)
            }
            if let checkImageView = verificationImageView {
                $0.addSubview(checkImageView)
            }
            if let actionButton = actionButton {
                $0.addSubview(actionButton)
            }
            if let verificationMessageLabel = verificationMessageLabel {
                $0.addSubview(verificationMessageLabel)
            }
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(UIScreen.main.bounds.width * 5.3/100.0)
        }
        
        inputTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel)
            $0.width.equalToSuperview().multipliedBy(66.0/100.0)
            $0.height.equalTo(35)
        }
        
        timerLabel?.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
            $0.top.bottom.equalTo(titleLabel)
        }
        
        verificationImageView?.snp.makeConstraints {
            $0.bottom.equalToSuperview()
        }
        
        actionButton?.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(UIScreen.main.bounds.width * 5.9/100.0)
            $0.width.equalToSuperview().multipliedBy(22.9/100.0)
            $0.height.equalTo(actionButton!.snp.width).multipliedBy(32.0/86.0)
        }
        
        verificationMessageLabel?.snp.makeConstraints {
            $0.top.equalTo(inputTextField.snp.bottom).offset(2)
            $0.leading.equalTo(inputTextField)
        }
    }
    
    // MARK: - Attributes
    
    func setupAttribute() {
        titleLabel.do {
            $0.font = .boldSystemFont(ofSize: 12)
            $0.textColor = .black
        }
        
        inputTextField.do {
            // FIXME: -
            $0.font = .systemFont(ofSize: 18)
            $0.textColor = .black
            // TODO: - underline이 있는 feature가 병합되면 추가할 예정
        }
        
        timerLabel?.do {
            $0.text = ""
            $0.textColor = .red
        }
        
        actionButton?.do {
            $0.layer.cornerRadius = 16
            $0.setTitleColor(.white, for: .normal)
            // FIXME:
            $0.backgroundColor = .blue
        }
        
        verificationMessageLabel?.do {
            $0.textColor = .red
            // FIXME: -
            $0.font = .systemFont(ofSize: 10)
        }
    }
    
    // MARK: - Configuration
    
    func configure(style: Style) {
        setUpComponentsIfNeeded(style: style)
        
        titleLabel.text = style.title
        inputTextField.placeholder = style.placeholder
        timerLabel?.text = style.timerString
        verificationImageView?.image = style.verificationImage
        actionButton?.titleLabel?.font = .systemFont(ofSize: 11)
        actionButton?.setTitle(style.buttonTitle, for: .normal)
        verificationMessageLabel?.text = style.vaildMessage
    }
    
    func setUpComponentsIfNeeded(style: Style) {
        if style.timerString != nil && timerLabel == nil {
            timerLabel = UILabel()
        }
        if style.verificationImage != nil && verificationImageView == nil {
            verificationImageView = UIImageView()
        }
        if style.buttonTitle != nil && actionButton == nil {
            actionButton = UIButton()
        }
        if style.vaildMessage != nil && verificationMessageLabel == nil {
            verificationMessageLabel = UILabel()
        }
    }
}

// MARK: - Style

extension InputFormView {
    
    
    struct Style {
        let title: String
        let placeholder: String
        let timerString: String?
        let verificationImage: UIImage?
        let buttonTitle: String?
        let vaildMessage: String?
        
        init(
            title: String,
            placeholder: String,
            timerString: String? = nil,
            verificationImage: UIImage? = nil,
            buttonTitle: String? = nil,
            vaildMessage: String? = nil
        ) {
            self.title = title
            self.placeholder = placeholder
            self.timerString = timerString
            self.verificationImage = verificationImage
            self.buttonTitle = buttonTitle
            self.vaildMessage = vaildMessage
        }
    }
}

extension InputFormView {
    
}
