//
//  BaseTableViewHeaderFooterView.swift
//  StarStarDiary
//
//  Created by suhyun on 2019/12/21.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit
import SnapKit

class BaseTableViewHeaderFooterView: UITableViewHeaderFooterView {

    // MARK: - Private Property
    
    private let baseView = UIView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let bottomView = UIView(frame: .zero)
    
    // MARK: - Public Set
    
    public func setEntity(title: String,
                          titleColor: UIColor?,
                          font: UIFont = UIFont.systemFont(ofSize: 12.0)) {
        if title == "" {
            bottomView.backgroundColor = .white216
            bottomView.isHidden = false
        } else {
            bottomView.isHidden = true
            titleLabel.text = title
            titleLabel.font = font
            titleLabel.textColor = titleColor
        }
    }
    
    // MARK: - Init
    
    private func initLayout() {
        self.addSubview(baseView)
        baseView.addSubview(titleLabel)
        baseView.addSubview(bottomView)

        baseView.do {
            $0.snp.makeConstraints {
                $0.edges.equalTo(self.snp.edges)
            }
        }
        
        titleLabel.do {
            $0.snp.makeConstraints {
                $0.leading.equalTo(self.snp.leading).offset(24.0)
                $0.trailing.equalTo(self.snp.trailing).inset(24.0)
                $0.bottom.equalTo(self.snp.bottom)
            }
        }
        
        bottomView.do {
            $0.snp.makeConstraints {
                $0.leading.equalTo(self.snp.leading)
                $0.trailing.equalTo(self.snp.trailing)
                $0.bottom.equalTo(self.snp.bottom)
                $0.height.equalTo(1.0)
            }
        }
    }
    
    private func initView() {
        baseView.backgroundColor = .white
    }
    
    // MARK: - Life Cycle

    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
        
        initLayout()
        initView()
    }
    
    convenience init() {
        self.init()
        
        initLayout()
        initView()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        initLayout()
        initView()
    }
}
