//
//  SideMenuViewController.swift
//  StarStarDiary
//
//  Created by Karen on 2019/12/17.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit

final class SideMenuViewController: UIViewController {

    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var menuBackgroundView: UIView!
    @IBOutlet weak var constellationImageView: UIImageView!
    @IBOutlet weak var constellationTextLabel: UILabel!
    @IBOutlet weak var constellationDateLabel: UILabel!
    @IBOutlet weak var constellationButton: UIButton!
    @IBOutlet weak var diaryListButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!

    // MARK: - Vars

    private var isShowing = false

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initBtn()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if isShowing == false {
            show()
        }
    }

    // MARK: - Init
    
    // FIXME: - 스토리보드 > snapKit 변경 작업시, 객체생성 함수 init+a() 그 외 setUp+a()

    private func initView() {
        dimView.alpha = 0.0

        view.backgroundColor = .dim
        menuBackgroundView.backgroundColor = .white

        // FIXME: - 유저 데이터로 변경해야함
        constellationTextLabel.do {
            $0.text = "처녀자리"
            $0.textAlignment = .center
        }

        constellationDateLabel.do {
            $0.text = "08.23 ~ 10.01"
            $0.textColor = .lightGray
            $0.adjustsFontSizeToFitWidth = true
            $0.textAlignment = .center
        }

        constellationImageView.do {
            $0.image = UIImage(named: "Virgo")
        }
    }

    private func initBtn() {
        
        // MARK: - Menu 가 닫히는 액션이 정확히 어떤 액션을 통해서 닫혀야하는지 확인 필요.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hide))
        self.view.addGestureRecognizer(tapGesture)

        constellationButton.do {
            $0.setTitle("별자리", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.textAlignment = .center
        }

        diaryListButton.do {
            $0.setTitle("보관함", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.textAlignment = .center
        }

        settingsButton.do {
            $0.setTitle("설   정", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.textAlignment = .center
            $0.addTarget(self,
                         action: #selector(didTapSettings(sender:)),
                         for: .touchUpInside)
        }
    }

    // MARK: - Animation

    private func show() {
        menuBackgroundView.do {
            $0.frame.origin.x = -(UIScreen.main.bounds.width + $0.frame.width)
        }

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn,
                       animations: { [weak self] in
            guard let self = self else { return }

            self.dimView.alpha = 1.0
            self.menuBackgroundView.frame.origin.x = .zero
        })

        isShowing = true
    }

    @objc
    private func hide() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn,
                       animations: { [weak self] in
            guard let self = self else { return }
                        
            self.dimView.alpha = 0.0
            self.menuBackgroundView.do {
                $0.frame.origin.x = -(UIScreen.main.bounds.width + $0.frame.width)
            }
        }, completion: { [weak self] isFinished in
            guard let self = self else { return }

            if isFinished {
                self.isShowing = false
                self.dismiss(animated: false, completion: nil)
            }
        })
    }

    // MARK: - Event

    @objc
    private func didTapSettings(sender: AnyObject?) {
        let viewController = SettingsViewController()
        viewController.do {
            $0.modalPresentationStyle = .fullScreen
            self.present($0, animated: true, completion: nil)
        }
    }

}
