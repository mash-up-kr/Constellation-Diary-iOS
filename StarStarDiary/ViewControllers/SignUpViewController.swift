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

class SignUpViewController: FormBaseViewController {
    
    init(token: Token, email: String) {
        self.token = token
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let token: Token
    private let email: String
    
    // MARK: - UI
    
    private let progressStepLabel = UILabel()
    private let idInputFormView = InputFormView(style: .id)
    private let passwordInputFormView = InputFormView(style: .signUpPassword)
    private let confirmPasswordInputFormView = InputFormView(style: .confirmPassword)

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
        
        idInputFormView.do {
            $0.delegate = self
        }
        
        passwordInputFormView.do {
            $0.delegate = self
        }
        
        confirmPasswordInputFormView.do {
            $0.delegate = self
        }
        
        nextButton.do {
            $0.setTitle("별별일기 시작하기", for: .normal)
            $0.addTarget(self, action: #selector(completionButtonDidTap), for: .touchUpInside)
        }
        inputFormViews.append(contentsOf: [self.idInputFormView, self.passwordInputFormView, self.confirmPasswordInputFormView])
    }

    override func setupConstraints() {
        super.setupConstraints()
        view.do {
            $0.addSubview(progressStepLabel)
            $0.addSubview(idInputFormView)
            $0.addSubview(passwordInputFormView)
            $0.addSubview(confirmPasswordInputFormView)
        }
        
        progressStepLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(5)
            $0.top.equalTo(titleLabel).inset(15)
        }
        
        idInputFormView.snp.makeConstraints {
            $0.top.equalTo(progressStepLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        passwordInputFormView.snp.makeConstraints {
            $0.top.equalTo(idInputFormView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        confirmPasswordInputFormView.snp.makeConstraints {
            $0.top.equalTo(passwordInputFormView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(confirmPasswordInputFormView.snp.bottom).offset(48)
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
        guard let userId = idInputFormView.inputText,
            let password = passwordInputFormView.inputText else { return }
        Provider.request(.signUp(constellation: UserDefaults.constellation.name, email: email, password: password, userId: userId), completion: { [weak self] (data: UserInfoDto) in
            UserDefaults.currentToken = data.tokens.authenticationToken
            UserDefaults.refreshToken = data.tokens.refreshToken
            UserManager.share.login(with: data.user)
            DispatchQueue.main.async { [weak self] in
                self?.showConstellationSelectionView()
            }
        }, failure: { error in
            // FIXME
        })
        showConstellationSelectionView()
        
    }
    
    private func showConstellationSelectionView() {
        guard let window = self.view.window else { return }
        window.rootViewController?.dismiss(animated: false, completion: nil)
        let selectVC = ConstellationSelectionViewController()
        selectVC.bind(type: .select)
        window.rootViewController = UINavigationController(rootViewController: selectVC)
        window.makeKeyAndVisible()
        
        selectVC.view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        selectVC.view.center = window.center
        
        UIView.transition(with: window,
                          duration: 0.3,
                          options: [.transitionCrossDissolve, .curveEaseOut],
                          animations: { selectVC.view.transform = .identity },
                          completion: nil)
    }
}

extension SignUpViewController: InputFormViewDelegate {

    func inputFormView(_ inputFormView: InputFormView, didTimerEnded style: InputFormViewStyle) {}
    func inputFormView(_ inputFormView: InputFormView, didTap button: UIButton) {}
    
    func inputFormView(_ inputFormView: InputFormView, didChanged text: String?) {
        if inputFormView === confirmPasswordInputFormView {
            inputFormView.verified = passwordInputFormView.verified && confirmPasswordInputFormView.inputText == self.passwordInputFormView.inputText
        }
    }
    
    func inputFormView(_ inputFormView: InputFormView, didExitEditing text: String?) {
        let allVerified = self.inputFormViews.allSatisfy { $0.verified }
        updateNextButton(enable: allVerified)
    }
    
}
