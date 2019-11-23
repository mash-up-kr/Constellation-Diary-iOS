//
//  BaseNavigationView.swift
//  StarStarDiary
//
//  Created by suhyun on 2019/11/24.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit
import SnapKit

class BaseNavigationView: UIView {
        
    var btnLeft = UIButton(frame: .zero)
    var btnRight = UIButton(frame: .zero)
    var btnTitle = UIButton(frame: .zero)
        
    // MARK: - Public
    
    public func setBtnLeft(image: UIImage?, addTargetType: AddTargetType) {
        btnLeft.setImage(image, for: .normal)
        btnLeft.addTarget(addTargetType.target,
                          action: addTargetType.action,
                          for: addTargetType.for)
    }
    
    public func setBtnRight(image: UIImage?, addTargetType: AddTargetType) {
        btnRight.setImage(image, for: .normal)
        btnRight.addTarget(addTargetType.target,
                          action: addTargetType.action,
                          for: addTargetType.for)
    }
    
    public func setBackgroundColor(color: UIColor) {
        self.backgroundColor = color
    }
    
    public func setTitle(title: String?, titleColor: UIColor, image: UIImage?) {
        btnTitle.setTitle(title, for: .normal)
        btnTitle.setTitleColor(titleColor, for: .normal)
        btnTitle.setImage(image, for: .normal)
    }
    
    // MARK: - Init
    
    private func initLayout() {
        self.addSubview(btnLeft)
        self.addSubview(btnRight)
        self.addSubview(btnTitle)
        
        btnLeft.do { (button) in
            button.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.height.width.equalTo(24.0)
                make.leading.equalTo(self.snp.leading).offset(20.0)
            }
        }
        
        btnRight.do { (button) in
            button.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.height.width.equalTo(24.0)
                make.trailing.equalTo(self.snp.trailing).offset(-20.0)
            }
        }
        
        btnTitle.do { (button) in
            button.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.leading.equalTo(btnLeft.snp.trailing).offset(16.0)
                make.trailing.equalTo(btnRight.snp.leading).offset(-16.0)
            }
            
            button.titleLabel?.textAlignment = .center
        }

    }
    
    // MARK: - Life Cycle

    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initLayout()
    }
}
