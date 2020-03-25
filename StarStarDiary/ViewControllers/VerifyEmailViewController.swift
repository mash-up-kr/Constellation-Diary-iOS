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

class VerifyEmailViewController: FormBaseViewController {
    
    // MARK: - UI
    
    private let progressStepLabel = UILabel()
    private let emailInputFormView = InputFormView(style: .email)
    private let certificationNumberInputFormView = InputFormView(style: .certificationNumber)

    override func setupConstraints() {
        super.setupConstraints()
        view.do {
            $0.addSubview(progressStepLabel)
            $0.addSubview(emailInputFormView)
            $0.addSubview(certificationNumberInputFormView)
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
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(certificationNumberInputFormView.snp.bottom).offset(48)
        }
        
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        titleLabel.do {
            $0.text = "회원가입"
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
        
        certificationNumberInputFormView.do {
            $0.isHidden = true
            $0.delegate = self
        }
        
        nextButton.do {
            $0.setTitle("다음", for: .normal)
            $0.addTarget(self, action: #selector(completionButtonDidTap), for: .touchUpInside)
            $0.isHidden = true
        }
        inputFormViews.append(contentsOf: [self.emailInputFormView, self.certificationNumberInputFormView])
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
            updateNextButton(enable: true)
        }
    }

    func requestCertification(_ inputFormView: InputFormView) {
        guard let email = inputFormView.inputText else { return }
        Provider.request(API.authenticationNumbersToSignUp(email: email), completion: {[weak self] _ in
            inputFormView.actionButton.setTitle("다시 전송", for: .normal)
            self.map {
                $0.certificationNumberInputFormView.isHidden = false
                $0.certificationNumberInputFormView.inputTextField.becomeFirstResponder()
                $0.certificationNumberInputFormView.startTimer(duration: 60 * 10)
                $0.emailInputFormView.inputTextField.isUserInteractionEnabled = false
                self?.nextButton.isHidden = false
                self?.updateNextButton(enable: false)
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
            self?.updateNextButton(enable: false)
        })
    }

}
