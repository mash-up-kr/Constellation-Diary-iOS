//
//  FortuneItemView.swift
//  StarStarDiary
//
//  Created by juhee on 2020/01/26.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit

final class FortuneItemView: UIView {

    private let imageView: UIImageView = UIImageView(frame: .zero)
    private let label: UILabel = UILabel(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
        setupConstraints()
    }

    func bind(item: FortuneItem) {
        imageView.image = item.image
        label.text = item.title
    }

    private func setupViews() {
        addSubview(imageView)
        addSubview(label)
        imageView.do {
            $0.contentMode = .scaleAspectFit
            $0.frame.size = CGSize(width: 40, height: 40)
        }

        label.do {
            $0.frame.size = CGSize(width: 56, height: 20)
            $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            $0.textColor = .gray122
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
        }
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7.5)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).inset(3)
            $0.leading.trailing.equalToSuperview()
            $0.width.equalTo(56)
            $0.bottom.equalToSuperview().offset(1)
        }
    }

}
