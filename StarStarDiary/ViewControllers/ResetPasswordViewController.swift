//
//  ResetPasswordViewController.swift
//  StarStarDiary
//
//  Created by juhee on 2020/03/15.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit
import SnapKit

final class ResetPasswordViewController: FormBaseViewController {

    private let passwordInputFormView = InputFormView(style: .resetPassword)
    private let confirmPasswordInputFormView = InputFormView(style: .confirmPassword)
    private var nextButtonTopConstraintOriginal: Constraint?
    private var nextButtonTopConstraintOverTop: Constraint?
    
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
            self.nextButtonTopConstraintOriginal = $0.top.equalTo(confirmPasswordInputFormView.snp.bottom).offset(138).constraint
//            self.nextButtonTopConstraintOverTop = $0.top.equalTo(confirmPasswordInputFormView.snp.bottom).offset(48).constraint
        }
//        self.nextButtonTopConstraintOverTop?.deactivate()
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
    
    override func keyboardWillAppear(frame: CGRect, withDuration: TimeInterval, curve: UIView.AnimationOptions) {
        super.keyboardWillAppear(frame: frame, withDuration: withDuration, curve: curve)
        guard self.nextButtonTopConstraintOverTop == nil else { return }
        let buttonFrame = self.nextButton.frame
        let overlapHeight = buttonFrame.maxY - frame.origin.y
        guard overlapHeight > 0 else { return }
        let yPosition = frame.height + 10
        self.nextButton.snp.makeConstraints {
            self.nextButtonTopConstraintOverTop = $0.bottom.equalToSuperview().inset(yPosition).constraint
        }
        self.nextButtonTopConstraintOriginal?.deactivate()
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
        })
    }

}

extension ResetPasswordViewController: InputFormViewDelegate {

    func inputFormView(_ inputFormView: InputFormView, didTimerEnded style: InputFormViewStyle) {}
    
    func inputFormView(_ inputFormView: InputFormView, didTap button: UIButton) {}
    
    func inputFormView(_ inputFormView: InputFormView, didChanged text: String?) {
        if inputFormView == self.confirmPasswordInputFormView, text?.count == self.confirmPasswordInputFormView.inputText?.count {
            self.checkPasswords()
        }
    }

    func inputFormView(_ inputFormView: InputFormView, didChanged editign: Bool) {
        let activateConstraint = editign ? self.nextButtonTopConstraintOverTop : self.nextButtonTopConstraintOriginal
        let deactivateConstrint = editign ? self.nextButtonTopConstraintOriginal : self.nextButtonTopConstraintOverTop
        deactivateConstrint?.deactivate()
        activateConstraint?.activate()
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
        })
        if inputFormView == self.confirmPasswordInputFormView, editign == false {
            self.checkPasswords()
        }
    }
    
}

private extension ResetPasswordViewController {
    
    @objc func resetButtonDidTap() {
        guard let password = self.passwordInputFormView.inputText,
            self.confirmPasswordInputFormView.inputText == self.passwordInputFormView.inputText else { return }
        Provider.request(.modifyPassword(token: token, password: password), completion: { _ in
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func checkPasswords() {
        let isPasswordSame = self.confirmPasswordInputFormView.inputText == self.passwordInputFormView.inputText
        self.confirmPasswordInputFormView.updateValidate(force: passwordInputFormView.verified && isPasswordSame)

        if self.confirmPasswordInputFormView.verified == false {
            self.confirmPasswordInputFormView.setErrorMessage()
        } else {
            self.confirmPasswordInputFormView.clearErrorMessage()
        }
        let allVerified = self.inputFormViews.allSatisfy { $0.verified }
        self.updateNextButton(enable: allVerified)
    }

}
