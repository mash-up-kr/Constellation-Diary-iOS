//
//  OnBoardingViewController.swift
//  StarStarDiary
//
//  Created by juhee on 2019/12/19.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit
import SnapKit

protocol NavigationDelegate: class {
    func navigationDelegate(_ viewController: UIViewController, request toViewController: UIViewController)
}


final class OnBoardingViewController: UIViewController {
    
    private let backgrounImageView = UIImageView()
    private let titleImageView = UIImageView()
    private let loginButton = UIButton()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        layoutViews()
    }
    
    private func setupViews() {
        setupBackground()
        setupTitleView()
        setupSignInButton()
    }
    
    private func setupBackground() {
        backgrounImageView.do {
            $0.image = UIImage(named: "bgMain")
            $0.contentMode = .scaleAspectFill
            view.addSubview($0)
        }
    }

    func setupTitleView() {
        titleImageView.do {
            $0.image = UIImage(named: "splashTitle")
            $0.contentMode = .scaleAspectFit
            view.addSubview($0)
        }
    }
    
    private func setupSignInButton() {
        loginButton.do {
            $0.setTitle("회원가입/로그인", for: .normal)
            $0.titleLabel?.font = UIFont.font(.koreaYMJBold, size: 16)
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
        
        titleImageView.snp.makeConstraints { imageView in
            imageView.leading.equalToSuperview().inset(32)
            imageView.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(81)
        }
        
        loginButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(52)
        }
    }
    
    @objc private func didTapLoginButton(_ sender: Any?) {
        let loginViewController = LoginViewController()
        loginViewController.modalPresentationStyle = .pageSheet
        loginViewController.navigationDelegate = self
        present(loginViewController, animated: true, completion: nil)
    }

}

extension OnBoardingViewController: NavigationDelegate {

    func navigationDelegate(_ viewController: UIViewController, request toViewController: UIViewController) {
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 0.3
        }
        present(toViewController, animated: true, completion: nil)
    }

}
