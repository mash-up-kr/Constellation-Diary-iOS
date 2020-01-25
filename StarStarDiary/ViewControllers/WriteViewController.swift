//
//  WriteViewController.swift
//  StarStarDiary
//
//  Created by suhyun on 2019/11/23.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit
import SnapKit
import Then

/*
 * Wirte Diary ViewController
 */

typealias AddTargetType = (target: Any?, action: Selector, for: UIControl.Event)

class WriteViewController: UIViewController {

    // MARK: - Private Property
    
    private let navigationView = BaseNavigationView(frame: .zero)
    private let headerView = UIView(frame: .zero)
    private let bodyView = UIView(frame: .zero)

    // headerView
    private let titleTextField = UITextField(frame: .zero)
    private let headerViewBottomLine = UIView(frame: .zero)

    // bodyView
    private let contentsTextView = UITextView(frame: .zero)
    private let placeHodlerButton = UIButton(frame: .zero)
    
    private let contentsPlaceHolder: String = "오늘의 이야기를 들려주세요."
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        initLayout()
        initNavigationView()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // MARK: - Init
    
    private func initViews() {
        view.do {
            $0.addSubview(navigationView)
            $0.addSubview(headerView)
            $0.addSubview(bodyView)
            $0.backgroundColor = .white
        }
        headerView.do {
            $0.addSubview(titleTextField)
            $0.addSubview(headerViewBottomLine)
        }
        
        bodyView.do {
            $0.addSubview(contentsTextView)
            $0.addSubview(placeHodlerButton)
        }
        headerViewBottomLine.backgroundColor = .white216
        // FIXME : 폰트적용
        titleTextField.do {
            $0.font = UIFont.systemFont(ofSize: 20)
            $0.placeholder = "제목"
        }
        contentsTextView.font = UIFont.systemFont(ofSize: 16)
        placeHodlerButton.do {
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            $0.setTitle(contentsPlaceHolder, for: .normal)
            $0.setTitleColor(.gray114, for: .normal)
            $0.contentVerticalAlignment = .top
            $0.contentHorizontalAlignment = .leading
            $0.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
        }
    }

    private func initLayout() {
        navigationView.snp.makeConstraints {
            $0.height.equalTo(44.0)
            $0.top.equalTo(view.snp.topMargin)
            $0.leading.trailing.equalToSuperview()
        }

        headerView.snp.makeConstraints {
            $0.height.equalTo(68.0)
            $0.top.equalTo(navigationView.snp.bottom)
            $0.trailing.leading.equalToSuperview()
        }

        titleTextField.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview()
            $0.bottom.equalToSuperview().inset(8.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
        }
        
        headerViewBottomLine.snp.makeConstraints {
            $0.height.equalTo(1.0)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(titleTextField)
        }
        
        bodyView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.trailing.equalTo(headerView.snp.trailing)
            $0.leading.equalTo(headerView.snp.leading)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
        }
        
        contentsTextView.snp.makeConstraints {
            $0.top.equalTo(bodyView.snp.top).offset(24.0)
            $0.trailing.equalTo(titleTextField.snp.trailing)
            $0.leading.equalTo(titleTextField.snp.leading)
            $0.bottom.equalTo(bodyView.snp.bottom)
        }
        
        placeHodlerButton.snp.makeConstraints {
            $0.edges.equalTo(contentsTextView)
        }
    }
    
    private func initNavigationView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let leftTargetType: AddTargetType = (self, #selector(close(sender:)), .touchUpInside)
        let rightTargetType: AddTargetType = (self, #selector(done(sender:)), .touchUpInside)
        
        navigationView.setBackgroundColor(color: .clear) // test
        navigationView.setTitle(title: "일기 작성하기", titleColor: .black, image: nil) // test
        navigationView.setBtnLeft(image: UIImage(named: "icClose24"), addTargetType: leftTargetType)
        navigationView.setBtnRight(image: UIImage(named: "icComplete24"), addTargetType: rightTargetType)
    }
    
    // MARK: - Event
    @objc
    private func didTap(_ sender: UIButton) {
        placeHodlerButton.isHidden = true
        contentsTextView.becomeFirstResponder()
    }
    
    @objc
    private func close(sender: AnyObject?) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func done(sender: AnyObject?) {
        let title = titleTextField.text
        let contents = contentsTextView.text
        // TODO: - API call
        self.navigationController?.popViewController(animated: true)
    }

}
