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

    // FIXME : 버튼이 추가될 경우를 생각해서 stackview로 변경하기
    private let buttonLeft = UIButton(type: .system)
    private let buttonSubRight = UIButton(type: .system)
    private let buttonRight = UIButton(type: .system)
    private let buttonTitle = UIButton(type: .system)
    private let bottomLineView = UIView(frame: .zero)
    
    private let buttonSize: CGFloat = 24.0
    private let horizontalGap: CGFloat = 10.0
    private let buttonGap: CGFloat = 8.0
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initLayout()
    }

}

extension BaseNavigationView {
    
    func button(for type: BaseNavigationButtonType) -> UIButton {
        switch type {
        case .title:
            return self.buttonTitle
        case .left:
            return self.buttonLeft
        case .right:
            return self.buttonRight
        case .subRight:
            return self.buttonSubRight
        }
    }
    
    @discardableResult
    func setButton(type: BaseNavigationButtonType, image: UIImage?, addTargetType: AddTargetType) -> UIButton {
        let button = self.button(for: type)
        button.do {
            $0.setImage(image, for: .normal)
            $0.addTarget(addTargetType.target,
                              action: addTargetType.action,
                              for: addTargetType.for)
            $0.isHidden = false
            $0.tintColor = .black
        }
        return button
    }
    
    @discardableResult
    func setButton(type: BaseNavigationButtonType, title: String, color: UIColor? = .black, addTargetType: AddTargetType? = nil) -> UIButton {
        let button = self.button(for: type)
        button.do {
            $0.tintColor = color
            $0.setTitle(title, for: .normal)
            if let addTargetType = addTargetType {
                $0.addTarget(addTargetType.target,
                                  action: addTargetType.action,
                                  for: addTargetType.for)
            }
            $0.isHidden = false
        }
        return button
    }
    
    func setButtonImageColor(type: BaseNavigationButtonType, color: UIColor) {
        let button = self.button(for: type)
        if color == button.tintColor {
            return
        }
        button.do {
            $0.tintColor = color
            let image = $0.imageView?.image?.withRenderingMode(.alwaysTemplate)
            $0.imageView?.image = image
            $0.imageView?.tintColor = color
        }
        print("[caution] type: \(type), tintColor: \(color)")
    }
    
    func updateButton(type: BaseNavigationButtonType, isEnabled: Bool) {
        button(for: type).do {
            $0.isEnabled = isEnabled
        }
    }
    
    func setBackgroundColor(color: UIColor) {
        self.backgroundColor = color
    }
    
    func setTitle(title: String?, titleColor: UIColor, font: UIFont? = nil, addTargetType: AddTargetType? = nil) {
        buttonTitle.do {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(titleColor, for: .normal)
            $0.titleLabel?.font = font ?? UIFont.font(.koreaYMJBold, size: 16)
            $0.isEnabled = addTargetType != nil
            if let addTargetType = addTargetType {
                $0.addTarget(addTargetType.target,
                                  action: addTargetType.action,
                                  for: addTargetType.for)
            }
        }
    }

    func setTitle(image: UIImage?, addTargetType: AddTargetType? = nil) {
        buttonTitle.do {
            $0.setImage(image, for: .normal)
            $0.isUserInteractionEnabled = addTargetType != nil
            if let addTargetType = addTargetType {
                $0.addTarget(addTargetType.target,
                                  action: addTargetType.action,
                                  for: addTargetType.for)
            }
        }
    }
    
    func setBottomLine(isHidden: Bool) {
        bottomLineView.isHidden = isHidden
        
        if isHidden == false {
            bottomLineView.backgroundColor = .white216
        }
    }

}

private extension BaseNavigationView {
    
    func initLayout() {
        self.addSubview(buttonLeft)
        self.addSubview(buttonRight)
        self.addSubview(buttonSubRight)
        self.addSubview(buttonTitle)
        self.addSubview(bottomLineView)
        
        buttonLeft.do {
            $0.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.top.equalToSuperview()
                make.width.equalTo(buttonLeft.snp.height)
                make.leading.equalTo(self.snp.leading).offset(horizontalGap)
            }
            $0.isHidden = true
        }
        
        buttonRight.do {
            $0.snp.makeConstraints { (make) in
                make.centerY.top.equalToSuperview()
                make.width.equalTo(buttonRight.snp.height)
                make.leading.equalTo(buttonSubRight.snp.trailing)
                make.trailing.equalTo(self.snp.trailing).inset(horizontalGap)
            }
            $0.isHidden = true
        }
        
        buttonSubRight.do {
            $0.snp.makeConstraints { make in
                make.centerY.top.equalToSuperview()
                make.width.equalTo(buttonSubRight.snp.height)
            }
            $0.isHidden = true
        }
        
        buttonTitle.do { (button) in
            button.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
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

}

enum BaseNavigationButtonType {
    case left
    case right
    case subRight
    case title
}
