//
//  FindIdViewController.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/02/01.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit

final class FindIDViewController: UIViewController {
    
    // MARK: - UI
    
    private let titleLabel = UILabel()
    private let emailInputFormView = InputFormView(style: .email)
    private let nextButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupAttribute()
    }
}

// MARK: - Layouts

extension FindIDViewController {
    func setupLayout() {
        view.do {
            $0.backgroundColor = .white
            $0.addSubview(titleLabel)
            $0.addSubview(emailInputFormView)
            $0.addSubview(nextButton)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(64.0)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20.0)
        }
        
        emailInputFormView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32.0)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(emailInputFormView.snp.bottom).offset(138.0)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(386.0)
        }
    }
}

// MARK: - Attributes

extension FindIDViewController {
    func setupAttribute() {
        navigationController?.navigationBar.do {
            $0.setBackgroundImage(UIImage(), for: .default)
            $0.shadowImage = UIImage()
        }
        
        navigationItem.do{
            $0.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icClose24"),
                                                    style: .plain, target: self,
                                                    action: #selector(closeButtonDidTap))
            $0.rightBarButtonItem?.tintColor = .black
        }
        
        titleLabel.do {
            $0.text = "아이디 찾기"
            $0.font = .boldSystemFont(ofSize: 26.0)
        }
        
        emailInputFormView.do {
            $0.inputTextField.delegate = self
        }
        
        nextButton.do {
            $0.titleLabel?.font = .systemFont(ofSize: 16)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .gray
            $0.setTitle("다음", for: .normal)
            $0.layer.cornerRadius = 5
            $0.isEnabled = false
            $0.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        }
    }
}

// MARK: - Action

extension FindIDViewController {
    
    private func validateEmail(string: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: string)
    }
    
    @objc
    private func closeButtonDidTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func nextButtonDidTap() {
        
    }
}

// MARK: - UITextFieldDelegate

extension FindIDViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let string = textField.text else { return }
        
        if validateEmail(string: string) {
            nextButton.isEnabled = true
            nextButton.backgroundColor = .navy3
        } else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = .gray
        }
    }
}
