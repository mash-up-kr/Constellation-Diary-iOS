//
//  ConstellationSelectionViewFlowLayout.swift
//  StarStarDiary
//
//  Created by juhee on 2020/02/09.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit

class ConstellationSelectionViewFlowLayout: UICollectionViewFlowLayout {

    private let activeDistance: CGFloat = 200
    private let zoomFactor: CGFloat = 0.12

    override init() {
        super.init()

        scrollDirection = .horizontal
        minimumLineSpacing = 44
    }
    
    convenience init(itemSize: CGSize) {
        self.init()
        self.itemSize = itemSize
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView,
            let layoutAttributes = super.layoutAttributesForElements(in: rect) else { return nil }

        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)
        let rectAttributes = layoutAttributes.compactMap { $0.copy() as? UICollectionViewLayoutAttributes }
        
            rectAttributes
                .filter { $0.frame.intersects(visibleRect) }
                .forEach {
                    let distance = visibleRect.midX - $0.center.x
                    let normalizedDistance = distance / activeDistance

                    if distance.magnitude < activeDistance {
                        let zoom = 1 + zoomFactor * (1 - normalizedDistance.magnitude)
                        $0.transform3D = CATransform3DMakeScale(zoom, zoom, 1)
                        $0.zIndex = Int(zoom.rounded())
                    }
                }
        return rectAttributes
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return .zero }

        // Add some snapping behaviour so that the zoomed cell is always centered
        let origin = CGPoint(x: proposedContentOffset.x, y: 0)
        let size = collectionView.frame.size
        let targetRect = CGRect(origin: origin, size: size)

        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else {
            return .zero
        }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + size.width / 2

        for layoutAttributes in rectAttributes {
            let itemHorizontalCenter = layoutAttributes.center.x
            if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }

        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        guard let context = super.invalidationContext(forBoundsChange: newBounds) as? UICollectionViewFlowLayoutInvalidationContext else {
            fatalError()
        }
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }

}
