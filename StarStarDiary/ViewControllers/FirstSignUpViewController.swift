//
//  SignUpViewController.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/01/15.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit
import SnapKit
import Then

class FirstSignUpViewController: UIViewController {
    
    // MARK: - UI
    
    private let titleLabel = UILabel()
    private let progressStepLabel = UILabel()
    private let emailInputFormView = InputFormView(style: .email)
    private let certificationNumberInputFormView = InputFormView(style: .certificationNumber)
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

extension FirstSignUpViewController {
    func setUpLayout() {
        view.do {
            $0.addSubview(titleLabel)
            $0.addSubview(progressStepLabel)
            $0.addSubview(emailInputFormView)
            $0.addSubview(certificationNumberInputFormView)
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
        
        emailInputFormView.snp.makeConstraints {
            $0.top.equalTo(progressStepLabel.snp.bottom).offset(view.bounds.height * 4.2/100.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.bounds.height * 8.0/100)
        }
        
        certificationNumberInputFormView.snp.makeConstraints {
            $0.top.equalTo(emailInputFormView.snp.bottom).offset(view.bounds.height * 4.2/100.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.bounds.height * 8.0/100)
        }
        
        completionButton.snp.makeConstraints {
            $0.height.equalTo(view.bounds.height * 6.4/100.0)
            $0.bottom.equalToSuperview().inset(view.bounds.height/2)
            $0.leading.trailing.equalToSuperview().inset(view.bounds.width * 5.3/100.0)
        }
        
    }
}

// MARK: - Attributes

extension FirstSignUpViewController {
    func setUpAttribute() {
        titleLabel.do {
            $0.text = "회원가입"
            $0.font = .systemFont(ofSize: 26)
        }
        
        progressStepLabel.do {
            $0.text = "1/2"
            $0.textColor = .gray
            $0.font = .systemFont(ofSize: 12)
        }
        
        emailInputFormView.do {
            $0.setNeedsDisplay()
            $0.actionButton?.addTarget(self,
                                       action: #selector(requestCertificationButtonDidTap),
                                       for: .touchUpInside)
        }
        
        completionButton.do {
            $0.backgroundColor = .blue
            $0.setTitle("다음", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 16)
            $0.layer.cornerRadius = 5
            $0.addTarget(self, action: #selector(completionButtonDidTap), for: .touchUpInside)
        }
    }
}

// MARK: - Actions

extension FirstSignUpViewController {
    @objc
    func requestCertificationButtonDidTap(_ sender: UIButton) {
        // TODO: 로직 구현
    }
    
    @objc
    func completionButtonDidTap(_ sender: UIButton) {
        // TODO: 로직 구현
    }
}
