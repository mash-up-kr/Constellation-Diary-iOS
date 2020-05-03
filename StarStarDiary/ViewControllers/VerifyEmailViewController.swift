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
            inputFormView.updateValidate(force: false)
        }
    }
    
    func inputFormView(_ inputFormView: InputFormView, didChanged text: String?) {
        inputFormView.clearErrorMessage()
        if inputFormView === self.emailInputFormView {
            inputFormView.updateValidate()
            let verified = inputFormView.verified
            inputFormView.showActionButton(enable: verified)
        } else if inputFormView === self.certificationNumberInputFormView {
            guard let text = inputFormView.inputText, text.count >= 6 else { return }
            updateNextButton(enable: true)
        }
    }

    func inputFormView(_ inputFormView: InputFormView, didChanged editign: Bool) {
        inputFormView.updateValidate()
    }

}

private extension VerifyEmailViewController {

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
        }, failure: {[weak self] error in
            if error.code == .existEmail {
                self.map {
                    $0.certificationNumberInputFormView.stopTimer()
                    $0.emailInputFormView.updateValidate(force: false)
                    $0.showErrorView()
                }
            }
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
            self?.certificationNumberInputFormView.updateValidate(force: false)
            self?.certificationNumberInputFormView.inputTextField.text = nil
            self?.certificationNumberInputFormView.setErrorMessage()
            self?.updateNextButton(enable: false)
        })
    }
    
    func showErrorView() {
        let errorLabel = UILabel()
        errorLabel.do {
            $0.backgroundColor = .coral255
            $0.textColor = .white
            $0.font = UIFont.font(.notoSerifCJKBold, size: 13)
            $0.text = "이미 가입된 이메일입니다."
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 26
            $0.textAlignment = .center
            $0.sizeToFit()
            $0.frame.size = CGSize(width: $0.frame.width + 40, height: 52)
            $0.center = self.view.center
            $0.alpha = 0
            self.view.addSubview($0)
        }
        
        UIView.animateKeyframes(withDuration: 2, delay: 0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2/2) {
                errorLabel.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 1.7/2, relativeDuration: 0.3/2) {
                errorLabel.alpha = 0
            }
        }, completion: { _ in
            errorLabel.removeFromSuperview()
        })
        
    }
    
}
