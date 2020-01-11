//
//  UICollectionView+.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/01/12.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    // MARK: - Register
    
    func registerHeaderView<Header: Reusable>(type: Header.Type)
        where Header: UICollectionReusableView {
            register(
                Header.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: Header.reuseIdentifier
            )
    }
    
    func registerFooterView<Footer: Reusable>(type: Footer.Type)
        where Footer: UICollectionReusableView {
            register(
                Footer.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: Footer.reuseIdentifier
            )
    }
    
    func register<Cell: Reusable>(type: Cell.Type)
        where Cell: UICollectionViewCell {
            register(type.self, forCellWithReuseIdentifier: type.reuseIdentifier)
    }
    
    // MARK: - Dequeue Reusable View
    
    func dequeueReusableCell<Cell: Reusable>(with type: Cell.Type, for indexPath: IndexPath) -> Cell?
        where Cell: UICollectionViewCell {
            let cell = dequeueReusableCell(
                withReuseIdentifier: type.reuseIdentifier,
                for: indexPath
            )
            return cell as? Cell
    }
    
    func dequeueHeaderView<Header: Reusable>(with type: Header.Type, for indexPath: IndexPath) -> Header?
        where Header: UICollectionReusableView {
            let header = dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: Header.reuseIdentifier,
                for: indexPath
            )
            return header as? Header
    }
}
