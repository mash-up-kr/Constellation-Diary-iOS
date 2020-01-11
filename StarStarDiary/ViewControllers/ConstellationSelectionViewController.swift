//
//  ConstellationSelectionViewController.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/01/12.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit

class ConstellationSelectionViewController: UIViewController {
    
    // MARK: - UI
    
    let constellationCollectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: UICollectionViewFlowLayout())
    let startButton = UIButton()
    let messageLabel = UILabel()
    
    // MARK: - Properties
    private let boundary = UIScreen.main.bounds.width * 0.12
    private let padding = UIScreen.main.bounds.width * 0.06
    private let cardWidth = UIScreen.main.bounds.width * 0.64
    
}

// MARK: - Layouts

extension ConstellationSelectionViewController {
     func setUpLayout() {
        
    }
}

// MARK: - Attributes

extension ConstellationSelectionViewController {
    func setUpAttribute() {
        
    }
}

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
