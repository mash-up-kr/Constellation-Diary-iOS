//
//  HoroscopeDetailViewController.swift
//  StarStarDiary
//
//  Created by 이동영 on 2019/11/23.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit
import SnapKit
import Then

protocol HoroscopeDetailViewDelegate: class {
    func horoscopeDeatilView(_ viewController: HoroscopeDetailViewController, didTap button: UIButton)
}

enum HoroscopeDetailViewType {
    case writeDiary(diary: DiaryDto?)
    case changeConstellation
    case detail
    
    var buttonTitle: String {
        switch self {
        case .writeDiary(let diary):
        return diary == nil ? "일기 작성하기" : "일기 보기"
        case .changeConstellation:
            return "별자리 변경하기"
        case .detail:
            return ""
        }
    }
    
    var isButtonHidden: Bool {
        switch self {
        case .writeDiary, .changeConstellation:
            return false
        case .detail:
            return true
        }
    }
}

final class HoroscopeDetailViewController: UIViewController {
    
    weak var delegate: HoroscopeDetailViewDelegate?
    
    // MARK: - UI
    
    private let horoscopeHeaderView = HoroscopeHeaderView(frame: .zero)
    private let seperatorView = UIView()
    private let detailLabel = UILabel()
    private let completeButton = UIButton()
    private var type: HoroscopeDetailViewType?

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpAttributes()
        setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Configure
    
    func bind(data: HoroscopeDto, type: HoroscopeDetailViewType) {
        horoscopeHeaderView.bind(horoscope: data)
        detailLabel.text = data.content
        completeButton.setTitle(type.buttonTitle, for: .normal)
        completeButton.isHidden = type.isButtonHidden
    }
    
    @objc private func didTapCompleteButton(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegate?.horoscopeDeatilView(self, didTap: sender)
        }
    }
    
}
// MARK: - Layout & Attributes

private extension HoroscopeDetailViewController {
    
     func setUpAttributes() {
        view.do {
            $0.backgroundColor = .white
            $0.addSubview(horoscopeHeaderView)
            $0.addSubview(seperatorView)
            $0.addSubview(detailLabel)
            $0.addSubview(completeButton)
        }
        
        seperatorView.do {
            $0.backgroundColor = .white216
        }
        
        detailLabel.do {
            $0.numberOfLines = 0
            $0.font = UIFont.font(.notoSerifCJKRegular, size: 15)
            $0.textColor = .black
        }
        
        completeButton.do {
            $0.backgroundColor = .navy3
            $0.layer.cornerRadius = 5
            $0.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        }
    }
    
    func setUpConstraints() {
        horoscopeHeaderView.snp.makeConstraints {
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
