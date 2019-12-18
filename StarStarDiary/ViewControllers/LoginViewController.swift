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
    override func viewDidLoad() {
        super.viewDidLoad()

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
