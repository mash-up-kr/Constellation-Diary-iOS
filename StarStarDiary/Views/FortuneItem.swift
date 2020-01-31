//
//  FortuneItem.swift
//  StarStarDiary
//
//  Created by juhee on 2020/01/25.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit

enum FortuneItem: CaseIterable {
    case clothes
    case number
    case word
    case item
    
    var image: UIImage? {
        return UIImage(named: "icClothes48")
    }
    
    var title: String {
        switch self {
        case .clothes:
            return "스카프"
        case .number:
            return "3"
        case .word:
            return "운동"
        case .item:
            return "아령"
        }
    }

}
