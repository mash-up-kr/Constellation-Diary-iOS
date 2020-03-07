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
    
    private let titleLabel = UILabel()
    private let progressStepLabel = UILabel()
    private let idInputFormView = InputFormView(style: .id)
    private let passwordInputFormView = InputFormView(style: .signUpPassword)
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
            $0.addSubview(passwordInputFormView)
            $0.addSubview(confirmPasswordInputFormView)
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
        
        completionButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.top.equalTo(confirmPasswordInputFormView.snp.bottom).offset(48)
            $0.leading.trailing.equalToSuperview().inset(20)
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
            $0.delegate = self
        }
        
        passwordInputFormView.do {
            $0.delegate = self
        }
        
        confirmPasswordInputFormView.do {
            $0.delegate = self
        }
        
        completionButton.do {
            $0.backgroundColor = .gray122
            $0.isEnabled = false
            $0.setTitle("별별일기 시작하기", for: .normal)
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
        
        let allVerified = [idInputFormView, passwordInputFormView, confirmPasswordInputFormView]
                          .reduce(true, { $0 && $1.verified })
        completionButton.isEnabled = allVerified
        completionButton.backgroundColor = allVerified ? .navy3 : .gray122
    }
    
    
    
}
