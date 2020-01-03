//
//  LoginViewController.swift
//  StarStarDiary
//
//  Created by 이동영 on 2019/12/18.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - UI
    
    private let drawerHandleView = UIView()
    private let signInView = UIView()
    private let closeButton = UIButton()
    private let titleLabel = UILabel()
    private let findAccountButton = UIButton()
    private let signUpButton = UIButton()
    private let idLabel = UILabel()
    private let idTextField = UITextField()
    private let passwordLabel = UILabel()
    private let passwordTextField = UITextField()
    private let signInButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayouts()
        addKeyboardObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupAttributes()
        showSignInView()
    }
    
    deinit {
        removeKeyboardObserver()
    }
}

// MARK: - Attributes

extension LoginViewController {
    
    private func setupAttributes() {
        setupViews()
        setupLabels()
        setupTextFields()
        setupButtons()
    }
    
    private func setupViews() {
        presentingViewController?.view.alpha = 0.54
        
        view.do {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
            $0.addGestureRecognizer(recognizer)
        }
        
        signInView.do {
            $0.layer.cornerRadius = 10.0
            $0.backgroundColor = .white
            $0.frame = CGRect(x: 0,
                              y: UIScreen.main.bounds.height,
                              width: UIScreen.main.bounds.width,
                              height: 0)
        }
        
        drawerHandleView.do {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 1.5
        }
    }
    
    private func setupLabels() {
        titleLabel.do {
            $0.text = "로그인"
            // FIXME: Asset Font로 수정 예정
            $0.font = .boldSystemFont(ofSize: 26)
        }
        
        idLabel.do {
            $0.text = "아이디"
            // FIXME: Asset Font로 수정 예정
            $0.font = .systemFont(ofSize: 12)
        }
        
        passwordLabel.do {
            $0.text = "비밀번호"
            // FIXME: Asset Font로 수정 예정
            $0.font = .systemFont(ofSize: 12)
        }
    }
    
    private func setupTextFields() {
        idTextField.do {
            // FIXME: Asset Font로 수정 예정
            $0.placeholder = "아이디 입력"
            $0.underlined(with: .white216)
        }
        
        passwordTextField.do {
            // FIXME: Asset Font로 수정 예정
            $0.placeholder = "비밀번호 입력"
            $0.underlined(with: .white216)
        }
    }
    
    private func setupButtons() {
        closeButton.do {
            $0.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
            $0.setImage(UIImage(named: "icClose24"), for: .normal)
            $0.alpha = 0
        }
        
        findAccountButton.do {
            // FIXME: Asset Font로 수정 예정
            $0.addTarget(self, action: #selector(findAccountButtonDidTap), for: .touchUpInside)
            $0.setTitle("아이디 찾기", for: .normal)
            $0.setTitleColor(.buttonBlue, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 12)
        }
        
        signUpButton.do {
            // FIXME: Asset Font로 수정 예정
            $0.addTarget(self, action: #selector(signInButtonDidTap), for: .touchUpInside)
            $0.setTitle("회원가입", for: .normal)
            $0.setTitleColor(.buttonBlue, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 12)
        }
        
        signInButton.do {
            // FIXME: Asset Font로 수정 예정
            $0.addTarget(self, action: #selector(signInButtonDidTap), for: .touchUpInside)
            $0.setTitle("별별일기 시작하기", for: .normal)
            $0.titleLabel?.textColor = .white
            $0.backgroundColor = .buttonNavy
            $0.layer.cornerRadius = 5.0
            $0.alpha = 0
        }
    }
}

// MARK: - Action

extension LoginViewController {
    
    // MARK: View
    
    private func showSignInView() {
        self.signInView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(94.6/100)
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: TextField
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillAppear),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    private func keyboardWillAppear(notification: Notification) {
        resizeSignInView()
    }
    
    func resizeSignInView() {
        let duration = 0.3
        
        DispatchQueue.main.async {
            self.signInView.snp.updateConstraints {
                $0.top.equalToSuperview().offset(self.view.safeAreaInsets.top)
                $0.leading.trailing.bottom.equalToSuperview()
            }
            self.drawerHandleView.alpha = 0
            self.closeButton.alpha = 1
            self.signInButton.alpha = 1
            
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: Button
    
    @objc
    private func closeButtonDidTap(_ button: UIButton) {
        presentingViewController?.view.alpha = 1
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func findAccountButtonDidTap(_ button: UIButton) {
        // TODO: 차후 로직 구현
    }
    
    @objc
    private func signUpButtonDidTap(_ button: UIButton) {
        // TODO: 차후 로직 구현
    }
    
    @objc
    private func signInButtonDidTap(_ button: UIButton) {
        // TODO: 차후 로직 구현
    }
    
}

// MARK: - Layouts

extension LoginViewController {
    
    private func setupLayouts() {
        view.do {
            $0.addSubview(signInView)
        }
        
        signInView.do {
            $0.addSubview(drawerHandleView)
            $0.addSubview(closeButton)
            $0.addSubview(titleLabel)
            $0.addSubview(findAccountButton)
            $0.addSubview(signUpButton)
            $0.addSubview(idLabel)
            $0.addSubview(idTextField)
            $0.addSubview(passwordLabel)
            $0.addSubview(passwordTextField)
            $0.addSubview(signInButton)
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        let screen = UIScreen.main.bounds.inset(by: view.safeAreaInsets)
        
        signInView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(screen.height * 54.4/100)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        drawerHandleView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(screen.height * 2.5/100)
            $0.width.equalTo(screen.width * 6.4/100)
            $0.height.equalTo(screen.height * 0.4/100)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(screen.height * 2.0/100)
            $0.leading.equalToSuperview().offset(screen.width * 5.3/100)
            $0.width.height.equalTo(screen.height * 3.0/100)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(screen.height * 8.3/100)
            $0.leading.equalTo(closeButton)
        }
        
        findAccountButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(screen.height * 9.1/100)
            $0.leading.equalToSuperview().offset(screen.width * 63.2/100)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(findAccountButton)
            $0.leading.equalTo(findAccountButton.snp.trailing).offset(screen.width * 3.2/100)
        }
        
        idLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(screen.height * 4.2/100)
            $0.leading.equalTo(closeButton)
        }
        
        idTextField.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(screen.height * 1.0/100)
            $0.leading.trailing.equalToSuperview().inset(screen.width * 5.3/100)
            $0.height.equalTo(screen.height * 5.3/100)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(screen.height * 5.5/100)
            $0.leading.equalTo(closeButton)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(screen.height * 1.0/100)
            $0.leading.trailing.equalToSuperview().inset(screen.width * 5.3/100)
            $0.height.equalTo(screen.height * 5.3/100)
        }
        
        signInButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(screen.height * 4.8/100)
            $0.leading.trailing.equalToSuperview().inset(screen.width * 5.3/100)
            $0.height.equalTo(screen.height * 6.4/100)
        }
    }
}
