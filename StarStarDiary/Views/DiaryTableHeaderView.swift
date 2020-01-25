//
//  DiaryTableHeaderView.swift
//  StarStarDiary
//
//  Created by juhee on 2019/12/31.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit

final class DiaryTableHeaderView: UIView {
    
    init(title: String) {
        super.init(frame: .zero)
        setup()
        label.text = title
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private let label = UILabel()
    
    private func setup() {
        self.backgroundColor = .init(white: 1, alpha: 0.9)
        let topFillView = UIView()
        topFillView.backgroundColor = .systemGroupedBackground
        self.addSubview(topFillView)
        topFillView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(12)
        }
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .navy3
        self.addSubview(label)
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().inset(8)
        }
    }

}
