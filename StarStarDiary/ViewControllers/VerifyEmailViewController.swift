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
import Moya

class VerifyEmailViewController: UIViewController {
    
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

extension VerifyEmailViewController {
    func setUpLayout() {
        view.do {
            $0.addSubview(titleLabel)
            $0.addSubview(progressStepLabel)
            $0.addSubview(emailInputFormView)
            $0.addSubview(certificationNumberInputFormView)
            $0.addSubview(completionButton)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(64)
            $0.leading.equalToSuperview().offset(20)
        }
        
        progressStepLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(5)
            $0.top.equalTo(titleLabel).inset(15)
        }
        
        emailInputFormView.snp.makeConstraints {
            $0.top.equalTo(progressStepLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        certificationNumberInputFormView.snp.makeConstraints {
            $0.top.equalTo(emailInputFormView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        completionButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.top.equalTo(certificationNumberInputFormView.snp.bottom).offset(48)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
    }
}

// MARK: - Attributes

extension VerifyEmailViewController {
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
        
        emailInputFormView.do {
            $0.setNeedsDisplay()
            $0.actionButton.setTitle("인증메일받기", for: .normal)
            $0.actionButton.isHidden = false
            $0.delegate = self
        }
        
        completionButton.do {
            $0.backgroundColor = .buttonBlue
            $0.setTitle("다음", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 16)
            $0.layer.cornerRadius = 5
            $0.addTarget(self, action: #selector(completionButtonDidTap), for: .touchUpInside)
            $0.isEnabled = false
            $0.isHidden = true
        }
        
        certificationNumberInputFormView.do {
            $0.isHidden = true
            $0.delegate = self
        }
    }
}

// MARK: - Actions

extension VerifyEmailViewController: InputFormViewDelegate {
    func inputFormView(_ inputFormView: InputFormView, didTap button: UIButton) {
        if inputFormView === self.emailInputFormView {
            self.requestCertification(inputFormView)
        }
    }
    
    func inputFormView(_ inputFormView: InputFormView, didTimerEnded style: InputFormViewStyle) {
        if inputFormView === self.certificationNumberInputFormView {
            inputFormView.verified = false
        }
    }
    
    func inputFormView(_ inputFormView: InputFormView, didChanged text: String?) {
        let verified = inputFormView.verified
        if inputFormView === self.emailInputFormView {
            inputFormView.actionButton.backgroundColor = verified ? .buttonBlue : .gray122
            inputFormView.actionButton.isEnabled = verified
        } else if inputFormView === self.certificationNumberInputFormView {
            guard let text = inputFormView.inputText, text.count >= 6 else { return }
            updateCompletionButton(enable: true)
        }
    }

    func requestCertification(_ inputFormView: InputFormView) {
        guard let email = inputFormView.inputText else { return }
        Provider.request(API.authenticationNumbersToSignUp(email: email), completion: {[weak self] _ in
            inputFormView.actionButton.setTitle("다시 전송", for: .normal)
            self.map {
                $0.certificationNumberInputFormView.isHidden = false
                $0.certificationNumberInputFormView.inputTextField.becomeFirstResponder()
                $0.certificationNumberInputFormView.startTimer(duration: 180)
                $0.emailInputFormView.inputTextField.isUserInteractionEnabled = false
                self?.completionButton.isHidden = false
                self?.updateCompletionButton(enable: false)
            }
        }, failure: {
            print($0)
        })
    }
    
    @objc
    func completionButtonDidTap(_ sender: UIButton) {
        guard let email = emailInputFormView.inputText,
            let numberString = certificationNumberInputFormView.inputText,
            let number = Int(numberString) else { return }
        Provider.request(API.authenticationToSignUp(email: email, number: number), completion: { [weak self] (data: AuthenticationTokenDto) in
            self?.certificationNumberInputFormView.stopTimer()
            let nextVC = SignUpViewController(token: data.token, email: email)
            self?.navigationController?.pushViewController(nextVC, animated: true)
        }, failure: { [weak self] _ in
            self?.certificationNumberInputFormView.verified = false
            self?.certificationNumberInputFormView.inputTextField.text = nil
            self?.updateCompletionButton(enable: false)
        })
    }
    
    private func updateCompletionButton(enable: Bool) {
        completionButton.isEnabled = enable
        completionButton.backgroundColor = enable ? .navy3 : .gray122
    }
}
