//
//  ConstellationSelectionViewController.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/01/12.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit

final class ConstellationSelectionViewController: UIViewController {
    
    // MARK: - UI
    
    private let backgrounImageView = UIImageView()
    private let constellationCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then { $0.scrollDirection = .horizontal }
    )
    private let messageLabel = UILabel()
    private let startButton = UIButton()
    
    // MARK: - Properties
    
    private var constellations = Constellation.allCases
    private let boundary = UIScreen.main.bounds.width * 0.12
    private let padding = UIScreen.main.bounds.width * 0.06
    private let cardWidth = UIScreen.main.bounds.width * 0.64
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayout()
        setUpAttribute()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupInifinieScroll()
    }
}

// MARK: - Layouts

extension ConstellationSelectionViewController {
    private func setUpLayout() {
        let safeArea = view.safeAreaLayoutGuide.snp
        view.do {
            $0.addSubview(backgrounImageView)
            $0.addSubview(constellationCollectionView)
            $0.addSubview(messageLabel)
            $0.addSubview(startButton)
        }
        
        backgrounImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        constellationCollectionView.snp.makeConstraints {
            $0.top.lessThanOrEqualTo(safeArea.top).offset(120)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(420)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(constellationCollectionView.snp.bottom).offset(30)
            $0.top.equalTo(safeArea.bottom).inset(185)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        startButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeArea.bottom).inset(20)
            $0.height.equalTo(52)
        }
        messageLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        messageLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
    }
}

// MARK: - Attributes

extension ConstellationSelectionViewController {
    private func setUpAttribute() {
        backgrounImageView.do {
            $0.image = UIImage(named: "bg_main")
            $0.contentMode = .scaleAspectFill
        }
        
        constellationCollectionView.do {
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = false
            $0.dataSource = self
            $0.delegate = self
            $0.contentInsetAdjustmentBehavior = .always
            $0.collectionViewLayout = flowLayout
            $0.register(type: ConstellationCell.self)
        }
        
        messageLabel.do {
            $0.text = "당신의 별자리를 선택해 주세요"
            $0.font = UIFont.font(.notoSerifCJKRegular, size: 14)
            $0.textColor = UIColor.init(white: 1, alpha: 0.65)
            $0.textAlignment = .center
            $0.numberOfLines = 3
        }
        
        startButton.do {
            $0.titleLabel?.font = UIFont.font(.notoSerifCJKRegular, size: 16)
            $0.setTitle("별별일기 시작하기", for: .normal)
            $0.backgroundColor = .white
            $0.setTitleColor(.black, for: .normal)
            $0.layer.cornerRadius = 5
        }
    }
    
    private func setupInifinieScroll() {
        setupFakeData()
        let startOffsetX = cardWidth - boundary + padding
        constellationCollectionView.contentOffset = CGPoint(x: startOffsetX + 0.5, y: 0)
    }
    
    private func setupFakeData() {
        guard let first = constellations.first,
            let last = constellations.last
            else { return }
        
        constellations.insert(last, at: 0)
        constellations.append(first)
        constellationCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension ConstellationSelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return constellations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(with: ConstellationCell.self,
                                                            for: indexPath) else {
            return ConstellationCell()
        }
        
        let constellation = constellations[indexPath.row]
        cell.configure(constellation)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ConstellationSelectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let startOffsetX = cardWidth - boundary + padding
        let endOffsetX = scrollView.contentSize.width - (cardWidth * 3.0/2.0 + boundary - padding)
        let currentOffsetX = scrollView.contentOffset.x
        
        if startOffsetX > currentOffsetX {
            scrollView.contentOffset = CGPoint(x: endOffsetX - 0.5, y: 0)
        } else if endOffsetX < currentOffsetX {
            scrollView.contentOffset = CGPoint(x: startOffsetX + 0.5, y: 0)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ConstellationSelectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cardWidth, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
    }
}
