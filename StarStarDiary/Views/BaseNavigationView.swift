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
    
    // MARK: - Private Property

    private let btnLeft = UIButton(frame: .zero)
    private let btnRight = UIButton(frame: .zero)
    private let btnTitle = UIButton(frame: .zero)
    private let bottomLineView = UIView(frame: .zero)
    
    // MARK: - Init
    
    private func initLayout() {
        self.addSubview(btnLeft)
        self.addSubview(btnRight)
        self.addSubview(btnTitle)
        self.addSubview(bottomLineView)
        
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
                make.trailing.equalTo(self.snp.trailing).inset(20.0)
            }
        }
        
        btnTitle.do { (button) in
            button.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.leading.equalTo(btnLeft.snp.trailing).offset(16.0)
                make.trailing.equalTo(btnRight.snp.leading).inset(-16.0)
            }
            
            button.titleLabel?.textAlignment = .center
        }
        
        bottomLineView.do {
            $0.snp.makeConstraints {
                $0.leading.equalTo(self.snp.leading)
                $0.trailing.equalTo(self.snp.trailing)
                $0.bottom.equalTo(self.snp.bottom)
                $0.height.equalTo(1.0)
            }
        }

    }
    
    // MARK: - Life Cycle

    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
        
        initLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initLayout()
    }
    
    // MARK: - Public Function
    
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
    
    public func setBottomLine(isHidden: Bool) {
        bottomLineView.isHidden = isHidden
        
        if isHidden == false {
            bottomLineView.backgroundColor = .white216
        }
    }
}
