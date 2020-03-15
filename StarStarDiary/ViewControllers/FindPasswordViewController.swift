//
//  FindPasswordViewController.swift
//  StarStarDiary
//
//  Created by juhee on 2020/03/15.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit

final class FindPasswordViewController: FormBaseViewController {
    
    // MARK: - UI
    
    private let idInputFormView = InputFormView(style: .id)
    private let emailInputFormView = InputFormView(style: .email)
    private let certificationNumberInputFormView = InputFormView(style: .certificationNumber)
    
    override func setupAttributes() {
        super.setupAttributes()
        titleLabel.do {
            $0.text = "비밀번호 찾기"
        }
        
        nextButton.do {
            $0.setTitle("인증번호 받기", for: .normal)
            $0.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        }
        
        certificationNumberInputFormView.do {
            $0.actionButton.setTitle("다시 전송", for: .normal)
            $0.actionButton.isHidden = false
            $0.actionButton.addTarget(self, action: #selector(self.requestCertificationEmail), for: .touchUpInside)
        }
        
        self.inputFormViews = [self.idInputFormView, self.emailInputFormView, self.certificationNumberInputFormView]
        idInputFormView.delegate = self
        emailInputFormView.delegate = self
        certificationNumberInputFormView.delegate = self
        certificationNumberInputFormView.isHidden = true
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        view.do {
            $0.addSubview(idInputFormView)
            $0.addSubview(emailInputFormView)
            $0.addSubview(certificationNumberInputFormView)
        }
        
        idInputFormView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        emailInputFormView.snp.makeConstraints {
            $0.top.equalTo(idInputFormView.snp.bottom).offset(32)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.checkNextButton()
    }

}

extension FindPasswordViewController: InputFormViewDelegate {
    func inputFormView(_ inputFormView: InputFormView, didTap button: UIButton) {
        if inputFormView == self.certificationNumberInputFormView {
            // 다시 요청
            self.updateNextButton(enable: true)
        }
    }
    
    func inputFormView(_ inputFormView: InputFormView, didTimerEnded style: InputFormViewStyle) {
        self.updateNextButton(enable: false)
    }
    
    func inputFormView(_ inputFormView: InputFormView, didChanged text: String?) {
        let verified = inputFormView.verified
        if inputFormView === self.emailInputFormView {
            updateNextButton(enable: verified)
        } else if inputFormView === self.certificationNumberInputFormView {
            guard let text = inputFormView.inputText, text.count >= 6 else { return }
            updateNextButton(enable: true)
        }
        
        if self.certificationNumberInputFormView.isHidden, self.idInputFormView.verified, self.emailInputFormView.verified {
            self.updateNextButton(enable: true)
            return
        }
        self.checkNextButton()
    }
    
}

private extension FindPasswordViewController {
    
    @objc func nextButtonDidTap() {
        if self.certificationNumberInputFormView.isHidden {
            self.requestCertificationEmail()
        } else {
            self.requestVerifyCode()
        }
    }
    
    @objc func didTapFindPasswordButton() {
        self.navigationController?.pushViewController(FindPasswordViewController(), animated: true)
    }
    
    func checkNextButton() {
        if let certificationCode = self.certificationNumberInputFormView.inputText,
            certificationCode.count >= 6 {
            self.updateNextButton(enable: true)
            return
        }
    }
    
    func requestVerifyCode() {
        guard let email = self.emailInputFormView.inputText,
            let userID = self.idInputFormView.inputText,
            let inputCode = self.certificationNumberInputFormView.inputText,
        let codeNumber = Int(inputCode)
        else { return }
        Provider.request(API.authenticationToFindPassword(email: email, number: codeNumber, userId: userID), completion: {[weak self] (response: TempTokenResponse) in
            let resetPasswordViewController = ResetPasswordViewController()
            resetPasswordViewController.bind(token: response.token)
            self?.navigationController?.pushViewController(resetPasswordViewController, animated: true)
        }, failure: {[weak self] (error: ErrorData) in
            if error.code == 4102 {
                self?.certificationNumberInputFormView.verified = false
                self?.updateNextButton(enable: false)
            }
        })
    }

    @objc func requestCertificationEmail() {
        guard let email = self.emailInputFormView.inputText,
            let userID = self.idInputFormView.inputText else { return }
        Provider.request(API.authenticationNumbersToFindPassword(email: email, userId: userID), completion: {[weak self] _ in
            self?.certificationNumberInputFormView.do {
                $0.isHidden = false
                $0.actionButton.isHidden = false
                $0.verified = true
                $0.startTimer(duration: 180)
                $0.inputTextField.becomeFirstResponder()
            }
            self?.emailInputFormView.inputTextField.isUserInteractionEnabled = false
            self?.idInputFormView.inputTextField.isUserInteractionEnabled = false
            self?.updateNextButton(enable: false)
            self?.nextButton.setTitle("비밀번호 재설정", for: .normal)
        }, failure: {[weak self] error in
            print(error)
            if error.code == 4002 {
                self?.showErrorView()
            }
        })
    }
    
    func showErrorView() {
        let errorLabel = UILabel()
        errorLabel.do {
            $0.backgroundColor = .coral255
            $0.textColor = .white
            $0.font = UIFont.font(.notoSerifCJKBold, size: 13)
            $0.layer.cornerRadius = 26
            $0.frame.size = CGSize(width: 263, height: 52)
            $0.center = self.view.center
            $0.alpha = 0
            $0.text = "아이디 또는 이메일이 일치하지 않습니다."
            self.view.addSubview($0)
        }
        
        UIView.animateKeyframes(withDuration: 2, delay: 0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5/2) {
                errorLabel.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 1.5/2, relativeDuration: 1/2) {
                errorLabel.alpha = 0
            }
        }, completion: { _ in
            errorLabel.removeFromSuperview()
        })
        
    }

}
