//
//  MainViewController.swift
//  StarStarDiary
//
//  Created by juhee on 2019/11/23.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit
import SnapKit


class MainViewController: UIViewController {

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
        let menuItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(didTapMenuItem))
        self.navigationItem.setLeftBarButton(menuItem, animated: false)
        let storageItem = UIBarButtonItem(image: UIImage(named: "book"), style: .plain, target: self, action: #selector(didTapStorageItem))
        self.navigationItem.setRightBarButton(storageItem, animated: false)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    private func setupLabels() {
        dateLabel.textColor = .lightGray
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)

        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    private func setupEditImageView() {
        editImageView.image = UIImage(named: "edit")
        editImageView.contentMode = .scaleAspectFit
        editImageView.tintColor = .white
    }
    
    private func setupFortuneView() {
        fortuneView.backgroundColor = .white
        fortuneView.clipsToBounds = true
        fortuneView.layer.cornerRadius = 10
        fortuneView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.addSubview(fortuneView)
        
        fortuneView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(182.0)
            make.bottom.equalToSuperview()
        }
    }

    private func setupContainerView() {
        let container = UIView()
        container.addSubview(dateLabel)
        container.addSubview(titleLabel)
        container.addSubview(editImageView)
        view.addSubview(container)

        dateLabel.snp.makeConstraints { label in
            label.centerX.equalToSuperview()
            label.leading.greaterThanOrEqualToSuperview()
            label.top.equalToSuperview().inset(15.0)
        }
        titleLabel.snp.makeConstraints { label in
            label.centerX.equalToSuperview()
            label.top.equalTo(dateLabel.snp.bottom).offset(8.0)
        }
        editImageView.snp.makeConstraints { imageView in
            imageView.centerX.equalToSuperview()
            imageView.width.height.equalTo(19.0)
            imageView.top.equalTo(titleLabel.snp.bottom).offset(19.0)
            imageView.bottom.equalToSuperview().inset(12.0)
        }
        
        let blankView = UIView()
        view.addSubview(blankView)
        
        blankView.snp.makeConstraints { blank in
            blank.leading.trailing.equalToSuperview()
            blank.top.equalToSuperview()
            blank.bottom.equalTo(fortuneView.snp.top)
        }
        
        container.snp.makeConstraints { container in
            container.centerX.equalToSuperview()
            container.leading.equalToSuperview().inset(76.0)
            container.centerY.equalTo(blankView.snp.centerY)
        }
    }

    // MARK: actions

    @objc private func didTapMenuItem() {
        // TODO : open side menu view controller
    }

    @objc private func didTapStorageItem() {
        // TODO : open diary list view controller
    }

    @objc private func didTapNewDiary() {
        // TODO : open diary Edit view controller
    }


}
