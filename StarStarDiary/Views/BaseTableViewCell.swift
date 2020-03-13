//
//  SettingBaseTableViewCell.swift
//  StarStarDiary
//
//  Created by suhyun on 2019/12/21.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit
import SnapKit

enum SettingBaseTableViewCellType {
    case hasOnlyTitle
    case hasValue
    case hasSwitch
    case hasArrow
    
    var accessoryType: UITableViewCell.AccessoryType {
        switch self {
        case .hasOnlyTitle, .hasSwitch, .hasValue:
            return .none
        case .hasArrow:
            return .disclosureIndicator
        }
    }

}

protocol SettingBaseTableViewCellDelegate: class {
    func settingBaseTableViewCell(_ cell: SettingBaseTableViewCell, didChange uiSwitch: UISwitch)
    func settingBaseTableViewCell(_ cell: SettingBaseTableViewCell, didChange datePicker: UIDatePicker)
}

class SettingBaseTableViewCell: UITableViewCell {
    
    weak var delegate: SettingBaseTableViewCellDelegate?

    private var titleLabel = UILabel(frame: .zero)
    private var bottomLineView = UIView(frame: .zero)
    private var labelStackView = UIStackView(frame: .zero)
    private var subTitleLabel = UILabel(frame: .zero)
    private var valueLabel = UILabel(frame: .zero)
    private var onOffSwitch = UISwitch(frame: .zero)
    private var contentsView = UIView(frame: .zero)
    private var contentsBottomLineView = UIView(frame: .zero)
    private (set) var datePickerView = UIDatePicker(frame: .zero)
    
    // MARK: - Internal Set

    func setEntity(titleString: String?, subTitleString: String?, valueString: String?, isOn: Bool = false, cellType: SettingBaseTableViewCellType, didExtension: Bool) {
        
        titleLabel.text = titleString
        subTitleLabel.text = subTitleString
        valueLabel.text = valueString
        onOffSwitch.isHidden = cellType != .hasSwitch
        onOffSwitch.isOn = isOn
        accessoryType = cellType.accessoryType
        contentView.isHidden = !didExtension
        selectionStyle = cellType == .hasSwitch ? .none : .default
    }
    
    func setEntity(with cellItem: SettingsViewCellItem) {
        self.setEntity(titleString: cellItem.title,
                       subTitleString: cellItem.subTitle,
                       valueString: cellItem.value,
                       isOn: cellItem.isOn,
                       cellType: cellItem.cellType,
                       didExtension: cellItem.didExtension)
    }

    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
        setupConstraints()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
        setupConstraints()
    }

}

private extension SettingBaseTableViewCell {
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(self.snp.leading).offset(20.0)
            $0.top.equalToSuperview()
            $0.height.equalTo(72.0)
        }
        
        onOffSwitch.snp.makeConstraints {
            $0.trailing.equalTo(self.snp.trailing).inset(20.0)
            $0.centerY.equalTo(titleLabel)
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8.0)
            $0.trailing.equalTo(self.snp.trailing).inset(20.0)
            $0.top.equalTo(self.snp.top)
            $0.height.equalTo(titleLabel.snp.height)
        }
        
        bottomLineView.snp.makeConstraints {
            $0.height.equalTo(1.0)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(labelStackView)
        }
        
        contentsView.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentsBottomLineView.snp.makeConstraints {
            $0.height.equalTo(1.0)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        datePickerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

    }
    
    // MARK: dark / light mode 적용 시, 변경이 필요할 수 있음
    func setupViews() {
        titleLabel.do {
            $0.font = UIFont.font(.notoSerifCJKMedium, size: 16.0)
            $0.textColor = .black
            $0.sizeToFit()
            self.addSubview($0)
        }
        
        subTitleLabel.do {
            $0.font = UIFont.font(.notoSerifCJKMedium, size: 14.0)
            $0.textAlignment = .left
            $0.textColor = UIColor.buttonBlue
            self.addSubview($0)
        }
        
        valueLabel.do {
            $0.font = UIFont.font(.notoSerifCJKMedium, size: 14.0)
            $0.textAlignment = .right
            $0.textColor = .lightGray
        }
    
        bottomLineView.do {
            $0.backgroundColor = .white216
            self.addSubview($0)
        }
        
        labelStackView.do {
            $0.distribution = .equalCentering
            $0.spacing = 8.0
            $0.axis = .horizontal
            $0.addArrangedSubview(subTitleLabel)
            $0.addArrangedSubview(valueLabel)
            self.addSubview($0)
        }
        
        onOffSwitch.do {
            $0.onTintColor = UIColor.navy3
            $0.addTarget(self, action: #selector(didChangeValue(switch:)), for: .valueChanged)
            self.addSubview($0)
        }
        
        contentsBottomLineView.do {
            $0.backgroundColor = .white216
        }
        
        contentsView.do {
            $0.addSubview(datePickerView)
            $0.addSubview(contentsBottomLineView)
            self.addSubview($0)
        }
        
        datePickerView.do {
            $0.datePickerMode = .time
            $0.locale = Locale.current
            $0.timeZone = TimeZone.current
            $0.addTarget(self, action: #selector(self.didChangeValue(datepicker:)), for: .valueChanged)
        }

    }
    
    @objc func didChangeValue(switch uiSwitch: UISwitch) {
        delegate?.settingBaseTableViewCell(self, didChange: uiSwitch)
    }

    @objc func didChangeValue(datepicker: UIDatePicker) {
        delegate?.settingBaseTableViewCell(self, didChange: datepicker)
    }

}
