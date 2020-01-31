//
//  FortuneDetailViewController.swift
//  StarStarDiary
//
//  Created by 이동영 on 2019/11/23.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit
import SnapKit
import Then

enum FortuneViewType {
    case writeDirary
    case selectConstellation
    
    var title: String {
        switch self {
        case .writeDirary:
            return "일기 쓰러 가기"
        case .selectConstellation:
            return "별자리 선택하기"
        }
    }
}

protocol FortuneDetailViewDelegate: class {
    func fortuneDeatilView(_ viewController: FortuneDetailViewController, didTap button: UIButton, with type: FortuneViewType)
}

final class FortuneDetailViewController: UIViewController {
    
    weak var delegate: FortuneDetailViewDelegate?
    
    // MARK: - UI
    
    private let fortuneHeaderView = FortuneHeaderView(frame: .zero)
    private let seperatorView = UIView()
    private let detailLabel = UILabel()
    private let completeButton = UIButton()
    
    private var viewType: FortuneViewType = .writeDirary
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpAttributes()
        setUpConstraints()
        // TOFO: - 실제 데이터 바인딩)
    }
    
    // MARK: - Configure
    
    func bind(items: [FortuneItem], viewType: FortuneViewType) {
        fortuneHeaderView.bind(items: FortuneItem.allCases)
        self.viewType = viewType
        completeButton.setTitle(viewType.title, for: .normal)
    }
    
    @objc private func writeDiary(_ sender: UIButton) {
        delegate?.fortuneDeatilView(self, didTap: sender, with: self.viewType)
    }
    
}
// MARK: - Layout & Attributes

extension FortuneDetailViewController {
    
    private func setUpAttributes() {
        view.do {
            $0.backgroundColor = .white
            $0.addSubview(fortuneHeaderView)
            $0.addSubview(seperatorView)
            $0.addSubview(detailLabel)
            $0.addSubview(completeButton)
        }
        
        seperatorView.do {
            $0.backgroundColor = .white216
        }
        
        detailLabel.do {
            $0.numberOfLines = 0
            $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            $0.textColor = .black
            // FIXME: - 실제 데이터 모델과 바인드
            $0.text = """
            활기찬 한 주가 되겠네요. 한 주를 시작하는 월요일부터 기운이 넘치는 주간입니다. 유난히 친구를 많이 만나게 됩니다.
            
            즐거운 시간이 많겠지만 건강관리는 좀 하셔야 합니다. 특정한 목적을 가진 만남은 좋지 않습니다. 취미나 동호회활동은 약간 기대에 모자란 정도입니다.
            """
        }
        
        completeButton.do {
            $0.backgroundColor = .navy3
            $0.layer.cornerRadius = 5
            $0.addTarget(self, action: #selector(writeDiary(_:)), for: .touchUpInside)
        }
    }
    
    private func setUpConstraints() {
        fortuneHeaderView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalTo(seperatorView.snp.top).offset(6)
        }

        seperatorView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(1)
        }

        detailLabel.snp.makeConstraints {
            $0.top.equalTo(seperatorView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(32)
        }

        completeButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(52)
        }
    }

}
