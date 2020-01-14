//
//  SecondSignUpViewController.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/01/15.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit
import SnapKit
import Then

class SecondSignUpViewController: UIViewController {
    
    // MARK: - UI
    
    private let titleLabel = UILabel()
    private let progressStepLabel = UILabel()
    private let idInputFormView = InputFormView(style: .id)
    private let passwordInputFormView = InputFormView(style: .password)
    private let confirmPasswordInputFormView = InputFormView(style: .confirmPassword)
    private let completionButton = UIButton()
    
    // MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUpLayout()
        setUpAttribute()
    }
}

// MARK: - Layouts

extension SecondSignUpViewController {
    func setUpLayout() {
        view.do {
            $0.addSubview(titleLabel)
            $0.addSubview(progressStepLabel)
            $0.addSubview(idInputFormView)
            $0.addSubview(passwordInputFormView)
            $0.addSubview(confirmPasswordInputFormView)
            $0.addSubview(completionButton)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(view.bounds.height * 7.9/100.0)
            $0.leading.equalToSuperview().offset(view.bounds.width * 5.3/100.0)
        }
        
        progressStepLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(5)
            $0.bottom.equalTo(titleLabel)
        }
        
        idInputFormView.snp.makeConstraints {
            $0.top.equalTo(progressStepLabel.snp.bottom).offset(view.bounds.height * 4.2/100.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.bounds.height * 8.0/100)
        }
        
        passwordInputFormView.snp.makeConstraints {
            $0.top.equalTo(idInputFormView.snp.bottom).offset(view.bounds.height * 4.2/100.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.bounds.height * 8.0/100)
        }
        
        confirmPasswordInputFormView.snp.makeConstraints {
            $0.top.equalTo(passwordInputFormView.snp.bottom).offset(view.bounds.height * 4.2/100.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.bounds.height * 8.0/100)
        }
        
        completionButton.snp.makeConstraints {
            $0.height.equalTo(view.bounds.height * 6.4/100.0)
            $0.bottom.equalToSuperview().inset(view.bounds.height * 38.0/100.0)
            $0.leading.trailing.equalToSuperview().inset(view.bounds.width * 5.3/100.0)
        }
        
    }
}

// MARK: - Attributes

extension SecondSignUpViewController {
    func setUpAttribute() {
        titleLabel.do {
            $0.text = "회원가입"
            $0.font = .systemFont(ofSize: 26)
        }
        
        progressStepLabel.do {
            $0.text = "2/2"
            $0.textColor = .gray
            $0.font = .systemFont(ofSize: 12)
        }
        
        idInputFormView.do {
            $0.setNeedsDisplay()
        }
        
        completionButton.do {
            $0.backgroundColor = .blue
            $0.setTitle("별별일기 시작하기", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 16)
            $0.layer.cornerRadius = 5
            $0.addTarget(self, action: #selector(completionButtonDidTap), for: .touchUpInside)
        }
    }
}

// MARK: - Actions

extension SecondSignUpViewController {
    @objc
    func completionButtonDidTap(_ sender: UIButton) {
        // TODO: 로직 구현
    }
}
