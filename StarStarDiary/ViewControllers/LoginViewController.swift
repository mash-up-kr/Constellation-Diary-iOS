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
        
        setupAttributes()
        setupConstraints()
        addKeyboardObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.frame.origin.y = self.view.frame.maxY - 336
    }
    
    deinit {
        removeKeyboardObserver()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        resizeSignInView()
    }
}

// MARK: - Action

extension LoginViewController {
    
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
        guard self.view.frame.origin != .zero else { return }
        let duration = 0.3

        UIView.animate(withDuration: duration) {
            self.view.frame.origin = .zero
            self.closeButton.isHidden = false
            self.signInButton.isHidden = false
        }
    }
    
    @objc
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: Button
    
    @objc
    private func closeButtonDidTap(_ button: UIButton) {
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
        self.resizeSignInView()
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

// MARK: - Attributes

private extension LoginViewController {
    
    func setupAttributes() {
        setupViews()
        setupLabels()
        setupTextFields()
        setupButtons()
    }
    
    func setupViews() {
        view.do {
            $0.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
            $0.backgroundColor = .white
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
            $0.addGestureRecognizer(recognizer)
        }
        
        drawerHandleView.do {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 1.5
            view.addSubview($0)
        }
    }
    
    private func setupLabels() {
        titleLabel.do {
            $0.text = "로그인"
            $0.font = UIFont.font(.notoSerifCJKMedium, size: 26)
            view.addSubview($0)
        }
        
        idLabel.do {
            $0.text = "아이디"
            $0.font = .systemFont(ofSize: 12)
            $0.font = UIFont.font(.notoSerifCJKMedium, size: 12)
            view.addSubview($0)
        }
        
        passwordLabel.do {
            $0.text = "비밀번호"
            $0.font = UIFont.font(.notoSerifCJKMedium, size: 12)
            view.addSubview($0)
        }
        
        errorMessageLabel.do {
            $0.font = .font(.notoSerifCJKMedium, size: 10)
            $0.textColor = .red
            view.addSubview($0)
        }
    }
    
    private func setupTextFields() {
        idTextField.do {
            $0.placeholder = "아이디 입력"
            $0.font = UIFont.font(.notoSerifCJKMedium, size: 18)
            $0.keyboardType = .emailAddress
            $0.autocapitalizationType = .none
            addUnderline(to: $0)
            view.addSubview($0)
        }
        
        passwordTextField.do {
            $0.placeholder = "비밀번호 입력"
            $0.font = UIFont.font(.notoSerifCJKMedium, size: 18)
            $0.isSecureTextEntry = true
            addUnderline(to: $0)
            view.addSubview($0)
        }
    }
    
    private func addUnderline(to textfield: UITextField) {
        UIView().do {
            textfield.addSubview($0)
            $0.backgroundColor = .white216
            $0.frame.size = CGSize(width: 1, height: 1)
            $0.frame.origin.y = textfield.bounds.maxY - 1
            $0.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        }
    }
    
    private func setupButtons() {
        closeButton.do {
            $0.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
            $0.setImage(UIImage(named: "icClose24"), for: .normal)
            $0.isHidden = true
            view.addSubview($0)
        }
        
        findAccountButton.do {
            $0.addTarget(self, action: #selector(findAccountButtonDidTap), for: .touchUpInside)
            $0.setTitle("아이디/비번찾기", for: .normal)
            $0.setTitleColor(.buttonBlue, for: .normal)
            $0.titleLabel?.font = UIFont.font(.notoSerifCJKMedium, size: 12)
            view.addSubview($0)
        }
        
        signUpButton.do {
            $0.addTarget(self, action: #selector(signUpButtonDidTap(_:)), for: .touchUpInside)
            $0.setTitle("회원가입", for: .normal)
            $0.setTitleColor(.buttonBlue, for: .normal)
            $0.titleLabel?.font = UIFont.font(.notoSerifCJKMedium, size: 12)
            view.addSubview($0)
        }
        
        signInButton.do {
            $0.addTarget(self, action: #selector(signInButtonDidTap), for: .touchUpInside)
            $0.setTitle("별별일기 시작하기", for: .normal)
            $0.titleLabel?.font = UIFont.font(.notoSerifCJKMedium, size: 16)
            $0.titleLabel?.textColor = .white
            $0.backgroundColor = .navy3
            $0.layer.cornerRadius = 5.0
            $0.isHidden = true
            view.addSubview($0)
        }
    }

// MARK: - Layouts
    
    func setupConstraints() {
        drawerHandleView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.width.equalTo(24)
            $0.height.equalTo(3)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(64)
            $0.leading.equalToSuperview().offset(20)
        }
        
        findAccountButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalTo(signUpButton.snp.leading).offset(-12)
        }
        
        signUpButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        idLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(20)
        }
        
        idTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(156)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(36)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(20)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(36)
        }
        
        errorMessageLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(20)
        }
        
        signInButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(48)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
    }

}
