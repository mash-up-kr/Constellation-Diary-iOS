//
//  FindIdViewController.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/02/01.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit

final class FindIDViewController: FormBaseViewController {
    
    // MARK: - UI

    private let emailInputFormView = InputFormView(style: .findID)
    private let findPasswordButton = UIButton()
    
    private var userID: String?

    override func setupConstraints() {
        super.setupConstraints()
        view.do {
            $0.addSubview(emailInputFormView)
            $0.addSubview(findPasswordButton)
        }
        
        emailInputFormView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(emailInputFormView.snp.bottom).offset(48)
        }
        
        findPasswordButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(titleLabel)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        titleLabel.do {
            $0.text = "아이디 찾기"
        }
        
        emailInputFormView.do {
            $0.delegate = self
            self.inputFormViews.append($0)
        }
        
        nextButton.do {
            $0.setTitle("다음", for: .normal)
            $0.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        }
    
        findPasswordButton.do {
            $0.isHidden = true
            $0.setTitle("비밀번호 찾기", for: .normal)
            $0.setTitleColor(.buttonBlue, for: .normal)
            $0.titleLabel?.font = UIFont.font(.notoSerifCJKMedium, size: 12)
            $0.addTarget(self, action: #selector(didTapFindPasswordButton), for: .touchUpInside)
        }
        
        self.inputFormViews.append(self.emailInputFormView)
    }

}

// MARK: - Action

private extension FindIDViewController {
    
    @objc private func nextButtonDidTap() {
        if self.userID == nil {
            requestFindID()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func didTapFindPasswordButton() {
        self.navigationController?.pushViewController(FindPasswordViewController(), animated: true)
    }

    func requestFindID() {
        guard let email = emailInputFormView.inputText else { return }
        self.updateNextButton(enable: false)
        Provider.request(API.findId(email: email), completion: {[weak self] (response: FindIDResponse) in
            self?.didFind(userID: response.userId)
        }, failure: {[weak self] (error: ErrorData) in
            if error.code == .notFoundID {
                self?.emailInputFormView.updateValidate(force: false)
                self?.emailInputFormView.setErrorMessage()
            }
        })
    }
    
    func didFind(userID: String) {
        let snapshotView = self.view.snapshotView(afterScreenUpdates: false)
        self.view.superview?.addSubview(snapshotView)
        self.userID = userID
        self.findPasswordButton.isHidden = false
        self.emailInputFormView.titleLabel.text = "아이디 찾기 결과"
        self.emailInputFormView.inputTextField.text = userID
        self.emailInputFormView.isUserInteractionEnabled = false
        self.nextButton.setTitle("로그인 하기", for: .normal)
        self.updateNextButton(enable: true)
        UIView.animate(withDuration: 0.3, animations: {
            snapshotView?.alpha = 0.2
        }, completion: { _ in
            snapshotView?.removeFromSuperview()
        })
    }
}

extension FindIDViewController: InputFormViewDelegate {

    func inputFormView(_ inputFormView: InputFormView, didChanged text: String?) {
        if inputFormView === self.emailInputFormView {
            inputFormView.updateValidate()
            updateNextButton(enable: inputFormView.verified)
        }
    }

    func inputFormView(_ inputFormView: InputFormView, didTimerEnded style: InputFormViewStyle) { }
    func inputFormView(_ inputFormView: InputFormView, didTap button: UIButton) { }
    func inputFormView(_ inputFormView: InputFormView, didChanged editign: Bool) { }

}
