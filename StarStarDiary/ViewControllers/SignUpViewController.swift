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

class SignUpViewController: UIViewController {
    
    // MARK: - UI
    
    private let titleLabel = UILabel()
    private let progressStepLabel = UILabel()
    private let firstStepView = UIView()
    private let secondStepView = UIView()
    private let emailInputFormView = InputFormView(style: .email)
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
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let backItem = UIBarButtonItem(image: UIImage(named: "icBack24"),
                                       style: .plain,
                                       target: self,
                                       action: #selector(dismiss(animated:completion:)))
        navigationItem.setLeftBarButton(backItem, animated: false)
        let closeItem = UIBarButtonItem(image: UIImage(named: "icClose24"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(self.dismiss))
        navigationItem.setRightBarButton(closeItem, animated: false)
        navigationController?.navigationBar.do {
            $0.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            $0.shadowImage = UIImage()
            $0.backgroundColor = UIColor.clear
            $0.tintColor = .black
        }
    }
    
    private func addBackItem() {
        let backItem = UIBarButtonItem(image: UIImage(named: "icBack24"),
                                       style: .plain,
                                       target: self,
                                       action: #selector(dismiss(animated:completion:)))
        navigationItem.setLeftBarButton(backItem, animated: false)
    }
}

// MARK: - Layouts

extension SignUpViewController {
    func setUpLayout() {
        view.do {
            $0.addSubview(titleLabel)
            $0.addSubview(progressStepLabel)
            $0.addSubview(idInputFormView)
        }
        
        firstStepView.do {
            $0.addSubview(passwordInputFormView)
        }
        
        secondStepView.do {
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

extension SignUpViewController {
    func setUpAttribute() {
        titleLabel.do {
            $0.text = "회원가입"
            $0.font = .font(.notoSerifCJKMedium, size: 26)
        }
        
        progressStepLabel.do {
            $0.text = "1/2"
            $0.textColor = .gray
            $0.font = .font(.notoSerifCJKMedium, size: 12)
        }
        
        idInputFormView.do {
            $0.setNeedsDisplay()
        }
        
        completionButton.do {
            $0.backgroundColor = .blue
            $0.setTitle("다음", for: .normal)
            $0.titleLabel?.font = .font(.notoSerifCJKMedium, size: 16)
            $0.layer.cornerRadius = 5
            $0.addTarget(self, action: #selector(completionButtonDidTap), for: .touchUpInside)
        }
    }
}

// MARK: - Actions

extension SignUpViewController {
    @objc
    func dismiss(_ sender: UIButton) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func completionButtonDidTap(_ sender: UIButton) {
        // TODO: 로직 구현
    }
}
