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

    private let dateLabel: UILabel          =       UILabel(frame: .zero)
    private let titleLabel: UILabel         =       UILabel(frame: .zero)
    private let editImageView: UIImageView  =       UIImageView(frame: .zero)
    private let fortuneView: UIView         =       UIView(frame: .zero)
    
    // MARK:- Methods
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: privates
    
    // FIXME :- rename method properly.
    private func bindDiary() {
        let dateFormatter = DateFormatter.defualtInstance
        dateFormatter.dateFormat = "YYYY년 MM월 dd일"
        dateLabel.text = dateFormatter.string(from: Date())
        // FIXME :- add real data
        titleLabel.text = "오늘 하루는 어땠나요?"
    }

    private func setupView() {
        view.backgroundColor = .black
        setupNavigationBar()
        setupLabels()
        setupEditImageView()
        setupFortuneView()
        setupContainerView()
        bindDiary()
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
    
    private func setupLabels() {
        dateLabel.textColor = .lightGray
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)

        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    private func setupEditImageView() {
        editImageView.do {
            $0.image = UIImage(named: "icEdit24")
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .white
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
        let blankView = UIView()
        view.addSubview(blankView)
        
        blankView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalTo(fortuneView.snp.top)
        }

        let container = UIView()
        container.do {
            $0.addSubview(dateLabel)
            $0.addSubview(titleLabel)
            $0.addSubview(editImageView)
            view.addSubview($0)
        }

        dateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview()
            $0.top.equalToSuperview().inset(15.0)
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dateLabel.snp.bottom).offset(8.0)
        }
        editImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(19.0)
            $0.top.equalTo(titleLabel.snp.bottom).offset(19.0)
            $0.bottom.equalToSuperview().inset(12.0)
        }
        container.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().inset(76.0)
            $0.centerY.equalTo(blankView.snp.centerY)
        }
        addTapGesture(container)
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
