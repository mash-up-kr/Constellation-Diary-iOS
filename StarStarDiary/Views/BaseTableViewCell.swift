//
//  SettingsTableViewCell.swift
//  StarStarDiary
//
//  Created by suhyun on 2019/12/21.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit
import SnapKit

class BaseTableViewCell: UITableViewCell {

    // Common
    private var titleLabel = UILabel(frame: .zero)
    private var bottomView = UIView(frame: .zero)
    
    // cellType에 따라서 바뀌는 Components
    private var subTitleLabel = UILabel(frame: .zero)
    private var onOffSwitch = UISwitch(frame: .zero)
    private var rightButton = UIButton(frame: .zero)
    
    // MARK: - Public Set
    
    public func setEntity(cell: SettingsViewCellItem) {
        
        titleLabel.text = cell.title
        subTitleLabel.text = cell.subTitle
        onOffSwitch.isOn = cell.isSwitchOn
        rightButton.setImage(cell.rightImage, for: .normal)
        bottomView.isHidden = cell.isHiddenBottomLine
        
        switch cell.cellType {
        case .hasOnlyTitle:
            subTitleLabel.isHidden = true
            onOffSwitch.isHidden = true
            rightButton.isHidden = true
        case .hasSubTitle:
            subTitleLabel.isHidden = false
            onOffSwitch.isHidden = true
            rightButton.isHidden = true
        case .hasRightImage:
            subTitleLabel.isHidden = true
            onOffSwitch.isHidden = true
            rightButton.isHidden = false
        case .hasRightSwitch:
            subTitleLabel.isHidden = true
            onOffSwitch.isHidden = false
            rightButton.isHidden = true
        }
    }
    
    // MARK: - Init
    
    private func initLayout() {
        self.addSubview(titleLabel)
        self.addSubview(bottomView)
        self.addSubview(subTitleLabel)
        self.addSubview(onOffSwitch)
        self.addSubview(rightButton)
        
        titleLabel.do {
            $0.snp.makeConstraints {
                $0.leading.equalTo(self.snp.leading).offset(24.0)
                $0.top.equalTo(self.snp.top)
                $0.bottom.equalTo(self.snp.bottom)
                
                $0.trailing.equalTo(subTitleLabel.snp.leading)
                $0.width.equalTo(subTitleLabel.snp.width).multipliedBy(1.7)
            }
        }
        
        subTitleLabel.do {
            $0.snp.makeConstraints {
                $0.trailing.equalTo(self.snp.trailing).inset(24.0)
                $0.top.equalTo(self.snp.top)
                $0.bottom.equalTo(self.snp.bottom)
            }
        }
        
        onOffSwitch.do {
            $0.snp.makeConstraints {
                $0.trailing.equalTo(subTitleLabel.snp.trailing)
                $0.centerY.equalTo(self.snp.centerY)
            }
        }
        
        rightButton.do {
            $0.snp.makeConstraints {
                // MARK: 전체 레이아웃 규칙을 일관적으로 적용하기 위해서는 아래 주석처럼 써야하는데,
                // 이미지가 작은데 버튼의 크기도 줄이면 터치 영역이 작아지니까 일단 이렇게 해둠
//                $0.trailing.equalTo(subTitleLabel.snp.trailing)
                $0.trailing.equalTo(self.snp.trailing)
                $0.height.equalToSuperview()
                $0.width.equalTo(rightButton.snp.height)
            }
        }
        
        bottomView.do {
            $0.snp.makeConstraints {
                $0.height.equalTo(1.0)
                $0.leading.equalToSuperview()
                $0.trailing.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
    }
    
    // MARK: dark / light mode 적용 시, 변경이 필요할 수 있음
    private func initView() {
        backgroundColor = .clear
        titleLabel.textColor = .black
        
        subTitleLabel.do {
            $0.textAlignment = .right
            $0.textColor = .lightGray
        }
        
        rightButton.do {
            $0.setTitle("", for: .normal)
        }
        
        bottomView.do {
            $0.backgroundColor = .white216
        }
    }
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initLayout()
        initView()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initLayout()
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
        
        initLayout()
        initView()
    }
}
