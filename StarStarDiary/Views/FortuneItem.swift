//
//  FortuneItem.swift
//  StarStarDiary
//
//  Created by juhee on 2020/01/25.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit

enum FortuneType: CaseIterable {
    case clothes
    case number
    case word
    case exercise
    
    var image: UIImage? {
        switch self {
        case .clothes:
            return UIImage(named: "icClothes48")
        case .number:
            return UIImage(named: "iconNumber")
        case .word:
            return UIImage(named: "iconWords")
        case .exercise:
            return UIImage(named: "iconWorkout")
        }
    
    }

}

struct FortuneItem {
    
    let type: FortuneType
    let text: String
    
}
