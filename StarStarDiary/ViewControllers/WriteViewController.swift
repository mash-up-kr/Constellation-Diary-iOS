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
    
    private var superview = UIView(frame: .zero)
    private let navigationView = BaseNavigationView(frame: .zero)
    private let headerView = UIView(frame: .zero)
    private let bodyView = UIView(frame: .zero)

    // headerView
    private let tfTitle = UITextField(frame: .zero)
    private let headerViewBottomLine = UIView(frame: .zero)

    // bodyView
    private let tvContents = UITextView(frame: .zero)
    
    // MARK: - Init

    private func initLayout() {
        superview = self.view

        superview.do { view in
            view.addSubview(navigationView)
            view.addSubview(headerView)
            view.addSubview(bodyView)
            
            view.backgroundColor = .white
        }

        // navigationView
        navigationView.do { view in
            view.snp.makeConstraints { (make) in
                make.height.equalTo(44.0)
                make.top.equalTo(superview.snp.topMargin)
                make.leading.trailing.equalToSuperview()
            }
        }
        
        // headerView
        headerView.do { view in
            view.addSubview(tfTitle)
            view.addSubview(headerViewBottomLine)

            view.snp.makeConstraints { make in
                make.height.equalTo(50.0)
                make.top.equalTo(navigationView.snp.bottom)
                make.trailing.equalTo(navigationView.snp.trailing)
                make.leading.equalTo(navigationView.snp.leading)
            }
        }
        
        tfTitle.do { view in
            view.snp.makeConstraints { make in
                make.height.equalTo(22.0)
                make.top.equalTo(20.0)
                make.leading.trailing.equalToSuperview().inset(20.0)
            }
        }
        
        headerViewBottomLine.do { view in
            view.snp.makeConstraints { make in
                make.height.equalTo(1.0)
                make.top.equalTo(tfTitle.snp.bottom)
                make.leading.equalTo(tfTitle.snp.leading)
                make.trailing.equalTo(tfTitle.snp.trailing)
            }
        }
        
        // bodyView
        bodyView.do { view in
            view.addSubview(tvContents)
            
            view.snp.makeConstraints { make in
                make.top.equalTo(headerView.snp.bottom)
                make.trailing.equalTo(headerView.snp.trailing)
                make.leading.equalTo(headerView.snp.leading)
                make.bottom.equalTo(superview.snp.bottomMargin)
            }
        }
        
        tvContents.do { view in
            view.snp.makeConstraints { make in
                make.top.equalTo(bodyView.snp.top).offset(24.0)
                make.trailing.equalTo(tfTitle.snp.trailing)
                make.leading.equalTo(tfTitle.snp.leading)
                make.bottom.equalTo(bodyView.snp.bottom)
            }
        }
    }
    
    private func initNavigationView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let leftTargetType: AddTargetType = (self, #selector(close(sender:)), .touchUpInside)
        let rightTargetType: AddTargetType = (self, #selector(done(sender:)), .touchUpInside)
        
        navigationView.setBackgroundColor(color: .clear) // test
        navigationView.setTitle(title: "test", titleColor: .black, image: nil) // test
        navigationView.setBtnLeft(image: UIImage(named: "close"), addTargetType: leftTargetType)
        navigationView.setBtnRight(image: UIImage(named: "check"), addTargetType: rightTargetType)
    }
    
    private func initView() {
        headerViewBottomLine.backgroundColor = .lightGray // test
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
        initNavigationView()
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        // test
        tfTitle.placeholder = "Title"
        tvContents.text = "Contents"
    }
    
    // MARK: - Event
    
    @objc
    private func close(sender: AnyObject?) {
        print(#function)
    }
    
    @objc
    private func done(sender: AnyObject?) {
        print(#function)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.view.endEditing(true)
    }
}
