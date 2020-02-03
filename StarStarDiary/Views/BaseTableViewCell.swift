//
//  SettingsTableViewCell.swift
//  StarStarDiary
//
//  Created by suhyun on 2019/12/21.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit
import SnapKit

enum BaseTableViewCellType {
    case hasOnlyTitle
    case hasValue
    case hasSwitch
    case hasArrow
}

class BaseTableViewCell: UITableViewCell {

    // Common
    private var titleLabel = UILabel(frame: .zero)
    private var bottomLineView = UIView(frame: .zero)
    
    // contentsView
    private var contentsView = UIView(frame: .zero)
    private var contentsBottomLineView = UIView(frame: .zero)
    
    // contentsView - datePicker
    private var datePickerView = UIDatePicker(frame: .zero)
    
    // cellType에 따라서 바뀌는 Components
    private var labelStackView = UIStackView(frame: .zero)
    private var subTitleLabel = UILabel(frame: .zero)
    private var valueLabel = UILabel(frame: .zero)
    private var onOffSwitch = UISwitch(frame: .zero)
    
    // MARK: - Public Set
    
    public func setEntity(titleString: String?, subTitleString: String?, valueString: String?, isSwitchOn: Bool?, canSelect: Bool, cellType: BaseTableViewCellType) {
        
        titleLabel.text = titleString
        subTitleLabel.text = subTitleString
        valueLabel.text = valueString
        selectionStyle = canSelect ? .default : .none
        
        if let isSwitchOn = isSwitchOn {
            onOffSwitch.isOn = isSwitchOn
            bringSubviewToFront(onOffSwitch)
        }
        
        switch cellType {
        case .hasOnlyTitle:
            onOffSwitch.isHidden = true
            accessoryType = .none
        case .hasValue:
            onOffSwitch.isHidden = true
            accessoryType = .none
        case .hasSwitch:
            onOffSwitch.isHidden = false
            accessoryType = .none
        case .hasArrow:
            onOffSwitch.isHidden = true
            accessoryType = .disclosureIndicator
        }
    }
    
    public func setDatePicker(mode: UIDatePicker.Mode) {
        datePickerView.datePickerMode = mode
    }
    
    // MARK: - Init
    
    private func initLayout() {
        self.addSubview(titleLabel)
        self.addSubview(bottomLineView)
        self.addSubview(onOffSwitch)
        self.addSubview(labelStackView)
        labelStackView.addArrangedSubview(subTitleLabel)
        labelStackView.addArrangedSubview(valueLabel)
        
        self.addSubview(contentsView)
        self.addSubview(contentsBottomLineView)
        contentsView.addSubview(datePickerView)
        
        titleLabel.do {
            $0.snp.makeConstraints {
                $0.leading.equalTo(self.snp.leading).offset(24.0)
                $0.trailing.equalTo(labelStackView.snp.leading).offset(-8.0)
                $0.top.equalToSuperview()
                $0.height.equalTo(72.0)
            }
        }
        
        labelStackView.do {
            $0.snp.makeConstraints {
                $0.trailing.equalTo(self.snp.trailing).inset(24.0)
                $0.top.equalTo(self.snp.top)
                $0.height.equalTo(titleLabel.snp.height)
            }
        }
        
        onOffSwitch.do {
            $0.snp.makeConstraints {
                $0.trailing.equalTo(self.snp.trailing).inset(24.0)
                $0.centerY.equalTo(labelStackView.snp.centerY)
            }
        }
        
        bottomLineView.do {
            $0.snp.makeConstraints {
                $0.height.equalTo(1.0)
                $0.leading.equalToSuperview()
                $0.trailing.equalToSuperview()
                $0.bottom.equalTo(labelStackView.snp.bottom)
            }
        }
        
        // contentsView
        
        contentsView.do {
            $0.snp.makeConstraints {
                $0.top.equalTo(labelStackView.snp.bottom)
                $0.leading.equalToSuperview()
                $0.trailing.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
        
        contentsBottomLineView.do {
            $0.snp.makeConstraints {
                $0.height.equalTo(1.0)
                $0.leading.equalToSuperview()
                $0.trailing.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
        
        // contentsView - datePickerView
        
        datePickerView.do {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
    }
    
    // MARK: dark / light mode 적용 시, 변경이 필요할 수 있음
    private func initView() {
        titleLabel.do {
            // TODO: 폰트 변경
            $0.font = UIFont.systemFont(ofSize: 16.0)
            $0.textColor = .black
            $0.sizeToFit()
        }
        
        subTitleLabel.do {
            // TODO: 폰트 변경
            $0.font = UIFont.systemFont(ofSize: 14.0)
            $0.textAlignment = .left
            $0.textColor = UIColor.buttonBlue
        }
        
        valueLabel.do {
            // TODO: 폰트 변경
            $0.font = UIFont.systemFont(ofSize: 14.0)
            $0.textAlignment = .right
            $0.textColor = .lightGray
        }
        
        bottomLineView.do {
            $0.backgroundColor = .white216
        }
        
        labelStackView.do {
            $0.distribution = .equalCentering
            $0.spacing = 8.0
            $0.axis = .horizontal
        }
        
        onOffSwitch.do {
            $0.onTintColor = UIColor.navy3
        }
        
        contentsBottomLineView.do {
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
        
        initLayout()
        initView()
    }
}
