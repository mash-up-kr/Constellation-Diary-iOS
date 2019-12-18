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
        
        setupAttributes()
        setupConstraints()
        addKeyboardObserver()
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
        self.view.do {
            $0.addSubview(signInView)
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                           action: #selector(hideKeyboard)))
        }
        
        signInView.do {
            $0.layer.cornerRadius = 10.0
            $0.backgroundColor = .white
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
        
        drawerHandleView.do {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 1.5
        }
    }
    
    private func setupLabels() {
        titleLabel.do {
            $0.text = "로그인"
            $0.font = .boldSystemFont(ofSize: 26)
        }
        
        idLabel.do {
            $0.text = "아이디"
            $0.font = .systemFont(ofSize: 12)
        }
        
        passwordLabel.do {
            $0.text = "비밀번호"
            $0.font = .systemFont(ofSize: 12)
        }
    }
    
    private func setupTextFields() {
        idTextField.do {
            $0.delegate = self
            $0.placeholder = "아이디 입력"
        }
        
        passwordTextField.do {
            $0.delegate = self
            $0.placeholder = "비밀번호 입력"
        }
    }
    
    private func setupButtons() {
        closeButton.do {
            $0.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
            // FIXME: Asset BackgroundImage 로 수정 예정
            $0.setTitle("X", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.isHidden = true
        }
        
        findAccountButton.do {
            $0.addTarget(self, action: #selector(findAccountButtonDidTap), for: .touchUpInside)
            // FIXME: Asset Color로 수정 예정
            $0.setTitle("아이디 찾기", for: .normal)
            $0.setTitleColor(.blue, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 12)
        }
        
        signUpButton.do {
            $0.addTarget(self, action: #selector(signInButtonDidTap), for: .touchUpInside)
            $0.setTitle("회원가입", for: .normal)
            // FIXME: Asset Color로 수정 예정
            $0.setTitleColor(.blue, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 12)
        }
        
        signInButton.do {
            $0.addTarget(self, action: #selector(signInButtonDidTap), for: .touchUpInside)
            $0.setTitle("로그인 하기", for: .normal)
            // FIXME: Asset Color로 수정 예정
            $0.backgroundColor = .blue
            $0.layer.cornerRadius = 5.0
            $0.isHidden = true
        }
    }
    
    private func updateAttributesWhenFullScreen() {
        self.drawerHandleView.isHidden = true
        self.closeButton.isHidden = false
        self.signInButton.isHidden = false
    }
}

        // Do any additional setup after loading the view.
// MARK: - Action

extension LoginViewController {
    
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
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
        updateConstraintsWhenFullScreen(duration: duration as? TimeInterval ?? 0)
        updateAttributesWhenFullScreen()
    }
    
    @objc
    private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: Button
    
    @objc
    private func closeButtonDidTap(_ button: UIButton) {
        // TODO: 차후 로직 구현
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
    
    private func setupConstraints() {
        let screen = UIScreen.main.bounds
        
        signInView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(screen.height * 48.3/100)
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
            $0.leading.equalTo(closeButton)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(screen.height * 5.5/100)
            $0.leading.equalTo(closeButton)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(screen.height * 1.0/100)
            $0.leading.equalTo(closeButton)
        }
        
        signInButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(screen.height * 4.8/100)
            $0.leading.trailing.equalToSuperview().inset(screen.width * 5.3/100)
            $0.height.equalTo(screen.height * 6.4/100)
        }
    }
    
    private func updateConstraintsWhenFullScreen(duration: TimeInterval) {
        self.signInView.snp.updateConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
}


}
