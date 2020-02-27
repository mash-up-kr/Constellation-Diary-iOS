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
    private let errorMessageLabel = UILabel()
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
            $0.font = UIFont.font(.notoSerifCJKMedium, size: 26)
        }
        
        idLabel.do {
            $0.text = "아이디"
            $0.font = .systemFont(ofSize: 12)
            $0.font = UIFont.font(.notoSerifCJKMedium, size: 12)
        }
        
        passwordLabel.do {
            $0.text = "비밀번호"
            $0.font = UIFont.font(.notoSerifCJKMedium, size: 12)
        }
        
        errorMessageLabel.do {
            $0.font = .font(.notoSerifCJKMedium, size: 10)
            $0.textColor = .red
        }
    }
    
    private func setupTextFields() {
        idTextField.do {
            $0.placeholder = "아이디 입력"
            $0.underlined(with: .white216)
            $0.font = UIFont.font(.notoSerifCJKMedium, size: 18)
            $0.keyboardType = .emailAddress
            $0.autocapitalizationType = .none
        }
        
        passwordTextField.do {
            $0.placeholder = "비밀번호 입력"
            $0.underlined(with: .white216)
            $0.font = UIFont.font(.notoSerifCJKMedium, size: 18)
            $0.isSecureTextEntry = true
        }
    }
    
    private func setupButtons() {
        closeButton.do {
            $0.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
            $0.setImage(UIImage(named: "icClose24"), for: .normal)
            $0.alpha = 0
        }
        
        findAccountButton.do {
            $0.addTarget(self, action: #selector(findAccountButtonDidTap), for: .touchUpInside)
            $0.setTitle("아이디/비번찾기", for: .normal)
            $0.setTitleColor(.buttonBlue, for: .normal)
            $0.titleLabel?.font = UIFont.font(.notoSerifCJKMedium, size: 12)
        }
        
        signUpButton.do {
            $0.addTarget(self, action: #selector(signUpButtonDidTap(_:)), for: .touchUpInside)
            $0.setTitle("회원가입", for: .normal)
            $0.setTitleColor(.buttonBlue, for: .normal)
            $0.titleLabel?.font = UIFont.font(.notoSerifCJKMedium, size: 12)
        }
        
        signInButton.do {
            $0.addTarget(self, action: #selector(signInButtonDidTap), for: .touchUpInside)
            $0.setTitle("별별일기 시작하기", for: .normal)
            $0.titleLabel?.font = UIFont.font(.notoSerifCJKMedium, size: 16)
            $0.titleLabel?.textColor = .white
            $0.backgroundColor = .navy3
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
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
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
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "아이디를 찾고 싶어요.", style: .default, handler: { [weak self] _ in
            self?.present(FindIDViewController(), animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "비밀번호를 찾고 싶어요.", style: .default, handler: { [weak self] _ in
            self?.present(FindIDViewController(), animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc
    private func signUpButtonDidTap(_ button: UIButton) {
        let navi = MultiStepNavigationController(rootViewController: VerifyEmailViewController())
        self.present(navi, animated: true, completion: nil)
    }
    
    @objc
    private func signInButtonDidTap(_ button: UIButton) {
        guard let token = UserDefaults.fcmToken,
            let password = self.passwordTextField.text,
            let userID = self.idTextField.text else {
                return
        }
        Provider.request(API.signIn(fcmToken: token, password: password, userId: userID), completion: { [weak self] (data: UserInfoDto) in
            UserDefaults.currentToken = data.tokens.authenticationToken
            UserDefaults.refreshToken = data.tokens.refreshToken
            UserManager.share.login(with: data.user)
            self?.navigateMain()
            
        }, failure: { [weak self] error in
            guard let error = error as? ErrorData else { return }
            self?.passwordTextField.text = nil
            self?.idTextField.text = nil
            switch error.code {
            case 4015:
                self?.errorMessageLabel.text = "아이디/비밀번호가 맞지 않습니다."
            default:
                self?.errorMessageLabel.text = "로그인에 실패했습니다. 다시 시도해주세요."
            }
        })
    }
    
    private func navigateMain() {
        // FIXME
        DispatchQueue.main.async {
            guard let window = self.view.window else { return }
            let mainViewController = MainViewController()
            let navi = UINavigationController(rootViewController: mainViewController)
            
            UIView.transition(from: self.view,
                              to: navi.view,
                              duration: 0.3,
                              options: [.transitionCrossDissolve],
                              completion: { _ in
                                window.rootViewController = navi
                                window.makeKeyAndVisible()
                            })
        }
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
            $0.addSubview(errorMessageLabel)
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
            $0.trailing.equalTo(self.signUpButton.snp.leading).offset(-12)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(findAccountButton)
            $0.trailing.equalToSuperview().inset(20)
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
        
        errorMessageLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(4)
            $0.leading.equalTo(passwordTextField.snp.leading)
        }
        
        signInButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(48)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
    }
}
