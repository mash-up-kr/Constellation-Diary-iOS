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
    
    private let titleLabel = UILabel(frame: .zero)
    private let bottomView = UIView(frame: .zero)
    
    // MARK: - Public Set
    
    public func setEntity(title: String,
                          titleColor: UIColor?,
                          font: UIFont = .font(StarStarFonts.notoSerifCJKRegular, size: 12.0)) {
        if title.isEmpty {
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
    
    private func initView() {
        
        UIView().do {
            $0.backgroundColor = .systemGroupedBackground
            self.backgroundView = $0
        }
        
        self.contentView.do {
            $0.addSubview(titleLabel)
            $0.addSubview(bottomView)
        }
        
        titleLabel.do {
            $0.snp.makeConstraints {
                $0.leading.equalTo(self.snp.leading).offset(20.0)
                $0.trailing.equalTo(self.snp.trailing).inset(20.0)
                $0.centerY.equalToSuperview()
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
    
    // MARK: - Life Cycle

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initView()
    }
    
    convenience init() {
        self.init()
        
        initView()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        initView()
    }
}
