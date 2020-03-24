//
//  SideMenuViewController.swift
//  StarStarDiary
//
//  Created by Karen on 2019/12/17.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit

final class SideMenuViewController: UIViewController {
    
    private var dimView = UIView(frame: .zero)
    
    private var menuBackgroundViewLeading: NSLayoutConstraint?
    private var menuBackgroundView = UIView(frame: .zero)
    private var constellationImageView = UIImageView(frame: .zero)
    private var constellationTextLabel = UILabel(frame: .zero)
    private var constellationDateLabel = UILabel(frame: .zero)
    
    private var lineView = UIView(frame: .zero)
    
    private var stackView = UIStackView(frame: .zero)
    private var constellationButton = UIButton(frame: .zero)
    private var diaryListButton = UIButton(frame: .zero)
    private var settingsButton = UIButton(frame: .zero)
    
    // MARK: - Vars

    private var isShowing = false
    private var horoscope: HoroscopeDto?

    // MARK: - Life Cycle

    convenience init(horoscope: HoroscopeDto?) {
        self.init()
        
        self.horoscope = horoscope
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        initView()
        initBtn()
        registerObserver()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if isShowing == false {
            show()
        }
    }

    // MARK: - Init

    func registerObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateConstellation), name: .didChangeConstellation, object: nil)
    }

    private func setupView() {
        
        view.addSubview(dimView)
        
        view.addSubview(menuBackgroundView)
        menuBackgroundView.addSubview(constellationImageView)
        menuBackgroundView.addSubview(constellationTextLabel)
        menuBackgroundView.addSubview(constellationDateLabel)
        menuBackgroundView.addSubview(lineView)
        
        menuBackgroundView.addSubview(stackView)
        stackView.addArrangedSubview(constellationButton)
        stackView.addArrangedSubview(diaryListButton)
        stackView.addArrangedSubview(settingsButton)
        
        dimView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        ///
        menuBackgroundViewLeading = menuBackgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        menuBackgroundViewLeading?.constant = -UIScreen.main.bounds.width*0.5
        menuBackgroundViewLeading?.isActive = true

        menuBackgroundView.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        
        ///
        constellationImageView.snp.makeConstraints {
            $0.width.height.equalTo(64.0)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.4)
        }
        
        constellationTextLabel.snp.makeConstraints {
            $0.leading.equalTo(constellationImageView.snp.leading)
            $0.trailing.equalTo(constellationImageView.snp.trailing)
            $0.top.equalTo(constellationImageView.snp.bottom).offset(16.0)
        }
        
        constellationDateLabel.snp.makeConstraints {
            $0.leading.equalTo(constellationImageView.snp.leading)
            $0.trailing.equalTo(constellationImageView.snp.trailing)
            $0.top.equalTo(constellationTextLabel.snp.bottom).offset(4.0)
        }
        
        lineView.snp.makeConstraints {
            $0.width.equalTo(24.0)
            $0.height.equalTo(1.0)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(constellationDateLabel.snp.bottom).offset(16.0)
            $0.bottom.equalTo(stackView.snp.top).offset(-16.0)
        }
        
        ///
        stackView.snp.makeConstraints {
            $0.leading.equalTo(constellationImageView.snp.leading)
            $0.trailing.equalTo(constellationImageView.snp.trailing)
        }
    }

    private func initView() {
        self.view.clipsToBounds = true
        view.backgroundColor = .clear
        menuBackgroundView.backgroundColor = .white

        constellationTextLabel.do {
            $0.textAlignment = .center
            $0.font = UIFont.font(.koreaYMJBold, size: 16.0)
            $0.adjustsFontSizeToFitWidth = true
        }

        constellationDateLabel.do {
            $0.text = "08.23 ~ 10.01"
            $0.textColor = .lightGray
            $0.textAlignment = .center
            $0.font = UIFont.font(.notoSerifCJKRegular, size: 10.0)
        }

        lineView.do {
            $0.backgroundColor = .black
        }
        
        stackView.do {
            $0.spacing = 8.0
            $0.axis = .vertical
        }
        
        dimView.do {
            $0.alpha = 0.0
            $0.backgroundColor = .dim

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hide))
            $0.addGestureRecognizer(tapGesture)
        }
    
        updateConstellation()
    }

    private func initBtn() {
        constellationButton.do {
            $0.setTitle("별자리", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.textAlignment = .center
            $0.addTarget(self,
                         action: #selector(didTapConstellations(sender:)),
                         for: .touchUpInside)
            $0.titleLabel?.font = UIFont.font(.notoSerifCJKRegular, size: 16.0)
        }

        diaryListButton.do {
            $0.setTitle("보관함", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.textAlignment = .center
            $0.addTarget(self,
                         action: #selector(didTapDiaryList(sender:)),
                         for: .touchUpInside)
            $0.titleLabel?.font = UIFont.font(.notoSerifCJKRegular, size: 16.0)
        }

        settingsButton.do {
            $0.setTitle("설   정", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.textAlignment = .center
            $0.addTarget(self,
                         action: #selector(didTapSettings(sender:)),
                         for: .touchUpInside)
            $0.titleLabel?.font = UIFont.font(.notoSerifCJKRegular, size: 16.0)
        }
    }

    // MARK: - Animation

    private func show() {
        
        self.menuBackgroundViewLeading?.constant = 0.0

        UIView.animate(withDuration: 0.25) {
            self.dimView.alpha = 1.0
            self.view.layoutIfNeeded()
        }

        isShowing = true
    }

    @objc
    private func hide() {
        self.menuBackgroundViewLeading?.constant = -self.view.bounds.width*0.5
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            guard let self = self else { return }
                        
            self.view.layoutIfNeeded()
            self.dimView.alpha = 0.0
        }) { [weak self] isFinished in
            guard let self = self else { return }

            if isFinished {
                self.isShowing = false
                self.dismiss(animated: false, completion: nil)
            }
        }
    }

    // MARK: - Event

    @objc
    private func didTapConstellations(sender: AnyObject?) {
        let viewController = ConstellationSelectionViewController()
        viewController.do {
            $0.bind(type: .horoscope)
            let navi = UINavigationController(rootViewController: $0)
            navi.modalPresentationStyle = .fullScreen
            self.present(navi, animated: true, completion: nil)
        }
    }

    @objc
    private func didTapSettings(sender: AnyObject?) {
        let viewController = SettingsViewController()
        viewController.do {
            $0.modalPresentationStyle = .fullScreen
            self.present($0, animated: true, completion: nil)
        }
    }
    
    @objc
    private func didTapDiaryList(sender: AnyObject?) {
        let viewController = DiaryListViewController(horoscope: horoscope)
        viewController.do {
            let navigationController = UINavigationController.init(rootViewController: $0)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    @objc func updateConstellation() {
        let constellation = UserDefaults.constellation
        constellationTextLabel.text = constellation.name
        constellationImageView.image = constellation.iconBlack
    }
    
}
