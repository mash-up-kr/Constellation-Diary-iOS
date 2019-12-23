//
//  MainViewController.swift
//  StarStarDiary
//
//  Created by juhee on 2019/11/23.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit
import SnapKit


final class MainViewController: UIViewController {

    // MARK:- Properties

    private let writeButton: UIButton          =       UIButton(frame: .zero)
    private let titleLabel: UILabel         =       UILabel(frame: .zero)
    private let editImageView: UIImageView  =       UIImageView(frame: .zero)
    private let fortuneView: UIView         =       UIView(frame: .zero)
    private let backgroundImageView: UIImageView = UIImageView(frame: .zero)
    
    // MARK:- Methods
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: privates
    
    // FIXME :- rename method properly.
    private func bindDiary() {
        titleLabel.text = "오늘 하루는 어땠나요?"
    }

    private func setupView() {
        view.backgroundColor = .black
        setupBackgroundImageView()
        setupNavigationBar()
        setupTitleLabel()
        setupFortuneView()
        setupContainerView()
        bindDiary()
    }
    
    private func setupBackgroundImageView() {
        backgroundImageView.do {
            $0.image = UIImage(named: "bg_main")
            $0.contentMode = .scaleAspectFill
            view.addSubview($0)
            $0.snp.makeConstraints { imageView in
                imageView.edges.equalToSuperview()
            }
        }
    }

    private func setupNavigationBar() {
        let menuItem = UIBarButtonItem(image: UIImage(named: "icMenu24"), style: .plain, target: self, action: #selector(didTapMenuItem))
        navigationItem.setLeftBarButton(menuItem, animated: false)
        let storageItem = UIBarButtonItem(image: UIImage(named: "icBook24"), style: .plain, target: self, action: #selector(didTapStorageItem))
        navigationItem.setRightBarButton(storageItem, animated: false)
        navigationController?.do {
            $0.navigationBar.tintColor = .white
            $0.navigationBar.isTranslucent = false
            $0.navigationBar.shadowImage = UIImage()
            $0.navigationBar.barTintColor = .black
            $0.navigationBar.barStyle = .black
        }
    }
    
    private func setupTitleLabel() {
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
    }
    
    private func setupWriteButton() {
        writeButton.do {
            $0.setTitle("일기작성 >", for: .normal)
            $0.setTitleColor(UIColor(white: 1, alpha: 0.7), for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        }
    }
    
    private func setupFortuneView() {
        fortuneView.do {
            $0.backgroundColor = .white
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
            $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            view.addSubview($0)

            $0.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(182.0)
                make.bottom.equalToSuperview()
            }
        }
    }

    private func setupContainerView() {
        let stackView = UIStackView()
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .leading
            $0.distribution = .equalSpacing
            $0.spacing = 25
            $0.addArrangedSubview(titleLabel)
            $0.addArrangedSubview(writeButton)
            view.addSubview($0)
        }

        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(48.0)
            $0.leading.equalToSuperview().inset(32.0)
        }
        addTapGesture(stackView)
    }
    
    private func addTapGesture(_ view: UIView) {
        view.do {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapNewDiary))
            $0.addGestureRecognizer(recognizer)
            $0.isUserInteractionEnabled = true
        }
    }

    // MARK: actions

    @objc private func didTapMenuItem() {
        // TODO : open side menu view controller
        let viewController = SideMenuViewController()
        viewController.modalPresentationStyle = .overFullScreen
        navigationController?.present(viewController, animated: false)
    }

    @objc private func didTapStorageItem() {
        let viewController = DiaryListViewController()
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.present(viewController, animated: true)
    }

    @objc private func didTapNewDiary() {
        navigationController?.pushViewController(WriteViewController(), animated: true)
    }


}
