//
//  ResetPasswordViewController.swift
//  StarStarDiary
//
//  Created by juhee on 2020/03/15.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit

final class ResetPasswordViewController: FormBaseViewController {

    private let passwordInputFormView = InputFormView(style: .resetPassword)
    private let confirmPasswordInputFormView = InputFormView(style: .confirmPassword)
    
    private var token: String = ""
    
    func bind(token: String) {
        self.token = token
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        view.do {
            $0.addSubview(passwordInputFormView)
            $0.addSubview(confirmPasswordInputFormView)
            $0.addSubview(nextButton)
        }
        
        passwordInputFormView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        confirmPasswordInputFormView.snp.makeConstraints {
            $0.top.equalTo(passwordInputFormView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(confirmPasswordInputFormView.snp.bottom).offset(138)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        titleLabel.do {
            $0.text = "비밀번호 재설정"
        }
        
        nextButton.do {
            $0.setTitle("로그인 하기", for: .normal)
            $0.addTarget(self, action: #selector(resetButtonDidTap), for: .touchUpInside)
        }
        
        passwordInputFormView.delegate = self
        confirmPasswordInputFormView.delegate = self
        inputFormViews.append(contentsOf: [self.passwordInputFormView, self.confirmPasswordInputFormView])
    }

}

extension ResetPasswordViewController: InputFormViewDelegate {

    func inputFormView(_ inputFormView: InputFormView, didTimerEnded style: InputFormViewStyle) {}
    
    func inputFormView(_ inputFormView: InputFormView, didTap button: UIButton) {}
    
    func inputFormView(_ inputFormView: InputFormView, didChanged text: String?) {
        if inputFormView === confirmPasswordInputFormView {
            inputFormView.verified = passwordInputFormView.verified && confirmPasswordInputFormView.inputText == self.passwordInputFormView.inputText
        }
        
        let allVerified = self.inputFormViews.allSatisfy { $0.verified }
        self.updateNextButton(enable: allVerified)
    }
    
}

private extension ResetPasswordViewController {
    
    @objc func resetButtonDidTap() {
        guard let password = self.passwordInputFormView.inputText else { return }
        Provider.request(.modifyPassword(token: token, password: password), completion: { _ in
            self.dismiss(animated: true, completion: nil)
        })
    }

}
