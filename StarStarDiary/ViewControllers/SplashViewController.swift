//
//  SplashViewController.swift
//  StarStarDiary
//
//  Created by juhee on 2020/03/05.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit
import Lottie
import SnapKit

class SplashViewController: UIViewController {

    private let backgroundImageView: UIImageView = UIImageView()
    private let lottieView = AnimationView()
    private let titleImageView = UIImageView()
    
    private var requestCount: Int = 0
    private let maxRetryCount: Int = 3

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        UserDefaults.currentToken = "eyJ0eXBlIjoiSldUIiwiYWxnIjoiSFMzODQifQ.eyJpc3MiOiJBUEkgU2VydmVyIiwic3ViIjoiQXV0aGVudGljYXRpb24gVG9rZW4iLCJleHAiOjE1ODI0NjM3MjgsImlhdCI6MTU4MjM3NzMyOCwidXNlcklkIjoicnVyZTExMTQiLCJpZCI6NH0.mBORyzTwY-KeveJ6C2g3mv-hAGXIb2v1D_1bkKTEOSVCUVJIl_7IsFUOPxVTjBM_"
        //        UserDefaults.refreshToken =  "eyJ0eXBlIjoiSldUIiwiYWxnIjoiSFMzODQifQ.eyJpc3MiOiJBUEkgU2VydmVyIiwic3ViIjoiUmVmcmVzaCBUb2tlbiIsImV4cCI6MTU4NDk2OTMyOCwiaWF0IjoxNTgyMzc3MzI4LCJ1c2VySWQiOiJydXJlMTExNCIsImlkIjo0fQ.3eaDfm9np9O0xsuSifJOusUl6yv1pUwBsByCWqwywF3c0cihUegjFwI8LYmrri9V"
        self.setupView()
        if UserDefaults.currentToken != nil {
            requestUser()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lottieView.play { [weak self] finished in
            if finished {
                self?.navigateInitialViewController()
            }
        }
        UIView.animate(withDuration: 1) {
            self.lottieView.alpha = 1
        }
    }

}

private extension SplashViewController {
    
    func setupView() {
        setupBackgroundImageView()
        setupLottieView()
        setupTitleView()
    }
    
    func setupLottieView() {
        lottieView.do {
            $0.alpha = 0
            $0.contentMode = .scaleAspectFill
            let animation = Animation.named("splash")
            $0.animation = animation
            $0.backgroundBehavior = .pauseAndRestore
            $0.loopMode = .playOnce
            view.addSubview($0)
            $0.snp.makeConstraints { lottie in
                lottie.edges.equalToSuperview()
            }
        }
    }
    
    func setupBackgroundImageView() {
        backgroundImageView.do {
            $0.image = UIImage(named: "bgMain")
            $0.contentMode = .scaleAspectFill
            view.addSubview($0)
            $0.snp.makeConstraints { imageView in
                imageView.edges.equalToSuperview()
            }
        }
    }
    
    func setupTitleView() {
        titleImageView.do {
            $0.image = UIImage(named: "splashTitle")
            $0.contentMode = .scaleAspectFit
            view.addSubview($0)
            $0.snp.makeConstraints { imageView in
                imageView.leading.equalToSuperview().inset(32)
                imageView.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(81)
            }
        }
    }
    
    func navigateInitialViewController() {
        if let dailyQuestion = UserManager.share.dailyQuestion {
            navigateMain(dailyQuestion: dailyQuestion)
        } else {
            navigateOnBoarding()
        }
    }
    
    func navigateMain(dailyQuestion: DailyQuestionDto) {
        let mainViewController = MainViewController()
        let navi = UINavigationController(rootViewController: mainViewController)
        navi.modalTransitionStyle = .crossDissolve
        navi.modalPresentationStyle = .fullScreen
        self.present(navi, animated: true, completion: nil)
    }
    
    func navigateOnBoarding() {
        let onboardingViewController = OnBoardingViewController()
        onboardingViewController.modalTransitionStyle = .crossDissolve
        onboardingViewController.modalPresentationStyle = .fullScreen
        self.present(onboardingViewController, animated: true, completion: nil)
    }

    func requestUser() {
        Provider.request(.users, completion: {[weak self] (data: UserDto) in
            UserManager.share.login(with: data)
            self?.requestDailyQuestion()
        }, failure: { [weak self] error in
            self?.requestCount += 1
            guard let strongSelf = self,
                strongSelf.requestCount < strongSelf.maxRetryCount,
                error.code == ErrorData.errorCodeUnauthrozed else {
                return
            }
            strongSelf.requestRefreshToken()
        })
    }

    func requestDailyQuestion() {
        Provider.request(.dailyQuestions, completion: {(data: DailyQuestionDto) in
            UserManager.share.updateDailyQuestion(with: data)
        })
    }
    
    func requestRefreshToken() {
        Provider.request(.refreshToken, completion: {[weak self] (tokens: TokenDto) in
            UserDefaults.currentToken = tokens.authenticationToken
            UserDefaults.refreshToken = tokens.refreshToken
            self?.requestDailyQuestion()
        }, failure: { _ in
            ()
        })
    }

}
