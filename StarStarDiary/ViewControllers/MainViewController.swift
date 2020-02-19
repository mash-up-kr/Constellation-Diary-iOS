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

    // MARK: - Properties

    private let writeButton: UIButton       =       UIButton(frame: .zero)
    private let titleLabel: UILabel         =       UILabel(frame: .zero)
    private let editImageView: UIImageView  =       UIImageView(frame: .zero)
    private let fortuneHeaderView: FortuneHeaderView = FortuneHeaderView(frame: .zero)
    private let backgroundImageView: UIImageView = UIImageView(frame: .zero)
    
    // MARK: - Methods
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    // MARK: privates
    
    // FIXME : - rename method properly.
    private func bindDiary() {
        titleLabel.text = "오늘 하루\n어떠셨나요?"
        fortuneHeaderView.bind(items: FortuneItem.allCases)
    }

    private func setupView() {
        view.backgroundColor = .black
        setupBackgroundImageView()
        setupNavigationBar()
        setupTitleLabel()
        setupWriteButton()
        setupFortuneView()
        setupContainerView()
        setupGestures()
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
        let menuItem = UIBarButtonItem(image: UIImage(named: "icMenu24"),
                                       style: .plain,
                                       target: self,
                                       action: #selector(didTapMenuItem))
        navigationItem.setLeftBarButton(menuItem, animated: false)
        let storageItem = UIBarButtonItem(image: UIImage(named: "icBook24"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(didTapStorageItem))
        navigationItem.setRightBarButton(storageItem, animated: false)
        let logoImageView = UIImageView(image: UIImage(named: "icStarVirgo40White"))
        logoImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = logoImageView
        navigationController?.navigationBar.do {
            $0.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            $0.shadowImage = UIImage()
            $0.backgroundColor = UIColor.clear
            $0.tintColor = .white
            $0.barStyle = .black
        }
    }
    
    private func setupTitleLabel() {
        titleLabel.do {
            $0.isUserInteractionEnabled = true
            $0.textColor = .white
            $0.font = UIFont.font(.koreaYMJBold, size: 30)
            $0.numberOfLines = 0
        }
    }
    
    private func setupWriteButton() {
        writeButton.do {
            $0.titleLabel?.font = UIFont.font(.notoSerifCJKMedium, size: 16)
            $0.setTitle("일기작성 >", for: .normal)
            $0.setTitleColor(UIColor(white: 1, alpha: 0.7), for: .normal)
        }
    }
    
    private func setupFortuneView() {
        fortuneHeaderView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
            $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            $0.isUserInteractionEnabled = true
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
            $0.isUserInteractionEnabled = true
            view.addSubview($0)
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapNewDiary))
            $0.addGestureRecognizer(recognizer)
            $0.isUserInteractionEnabled = true
        }

        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(104)
            $0.leading.equalToSuperview().inset(32.0)
        }
    }
    
    private func setupGestures() {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(
            target: self,
            action: #selector(openFortuneView)
        )
        swipeGestureRecognizer.direction = .up
        view.addGestureRecognizer(swipeGestureRecognizer)
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(openFortuneView)
        )
        fortuneHeaderView.addGestureRecognizer(tapGestureRecognizer)
    }

    // MARK: actions
    
    @objc private func openFortuneView() {
        let fortuneViewController = FortuneDetailViewController()
        fortuneViewController.bind(items: FortuneItem.allCases, viewType: .writeDirary)
        fortuneViewController.delegate = self
        navigationController?.present(fortuneViewController, animated: true, completion: nil)
    }

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
        self.navigationController?.pushViewController(WriteViewController(), animated: true)
    }

}

extension MainViewController: FortuneDetailViewDelegate {
    func fortuneDeatilView(_ viewController: FortuneDetailViewController, didTap button: UIButton, with type: FortuneViewType) {
        didTapNewDiary()
    }

}
