//
//  OnBoardingViewController.swift
//  StarStarDiary
//
//  Created by juhee on 2019/12/19.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit
import SnapKit

class OnBoardingViewController: UIViewController {
    
    private let backgrounImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let loginButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        layoutViews()
    }
    
    private func setupViews() {
        setupBackground()
        setupLables()
        setupSignInButton()
    }
    
    private func setupBackground() {
        backgrounImageView.do {
            $0.image = UIImage(named: "bg_main")
            $0.contentMode = .scaleAspectFill
            view.addSubview($0)
        }
    }
    
    private func setupLables() {
        titleLabel.do {
            $0.text = "별별일기"
            $0.font = UIFont.systemFont(ofSize: 32, weight: .bold)
            $0.textColor = .white
            view.addSubview($0)
        }
        
        descriptionLabel.do {
            $0.text = "당신만을 위한 별자리운세를\n매일 전해드릴게요."
            $0.numberOfLines = 2
            $0.textColor = .white
            $0.alpha = 0.7
            view.addSubview($0)
        }
    }
    
    private func setupSignInButton() {
        loginButton.do {
            $0.setTitle("회원가입/로그인", for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            $0.setTitleColor(.black, for: .normal)
            $0.addTarget(self, action: #selector(didTapLoginButton(_:)), for: .touchUpInside)
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 5.0
            view.addSubview($0)
        }
    }
    
    private func layoutViews() {
        backgrounImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(40)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(121)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        loginButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(52)
        }
    }
    
    @objc private func didTapLoginButton(_ sender: Any?) {
        // FiXME :- 동영이 코드 머지되면 붙일 예정
        let loginViewController = LoginViewController()
        loginViewController.modalPresentationStyle = .overFullScreen
        present(loginViewController, animated: true, completion: nil)
        
    }

}
