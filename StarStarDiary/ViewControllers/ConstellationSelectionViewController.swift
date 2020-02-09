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
    private lazy var fakeItemCount = self.constellations.count * 50
    
    // MARK: - Properties
    
    private var constellations = Constellation.allCases
    
    private var isHeightSmall: Bool {
        return self.view.frame.height < 700
    }

    private var itemSize: CGSize {
        return isHeightSmall ? CGSize(width: 225, height: 335) : CGSize(width: 240, height: 357)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayout()
        setUpAttribute()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let initialIndexPath = IndexPath(item: fakeItemCount / 2, section: 0)
        constellationCollectionView.scrollToItem(at: initialIndexPath,
                                                 at: .centeredHorizontally,
                                                 animated: false)
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
            $0.top.greaterThanOrEqualTo(safeArea.top).offset(40)
            $0.top.equalTo(safeArea.top).offset(40).priority(.low)
            $0.top.equalTo(safeArea.top).offset(120).priority(.medium)
            $0.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(375)
            $0.height.equalTo(400).priority(.low)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(constellationCollectionView.snp.bottom).offset(20)
            $0.top.equalTo(constellationCollectionView.snp.bottom).offset(30).priority(.medium)
            $0.bottom.lessThanOrEqualTo(safeArea.bottom).inset(124)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.greaterThanOrEqualTo(62)
        }
        
        startButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.lessThanOrEqualTo(safeArea.bottom).inset(20)
            $0.bottom.equalTo(safeArea.bottom).inset(35)
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
            let flowLayout = ConstellationSelectionViewFlowLayout(itemSize: itemSize)
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

}

// MARK: - UICollectionViewDataSource

extension ConstellationSelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return fakeItemCount
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(with: ConstellationCell.self,
                                                            for: indexPath) else {
            return ConstellationCell()
        }
        
        let index = indexPath.item % constellations.count
        let constellation = constellations[index]
        cell.configure(constellation)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ConstellationSelectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        let index = indexPath.item % constellations.count
        messageLabel.text = constellations[index].desc
        if let selectedCell = collectionView.cellForItem(at: indexPath) {
            selectedCell.isSelected = true
        }
    }

}
