//
//  UIFont+.swift
//  StarStarDiary
//
//  Created by juhee on 2020/01/31.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit

enum StarStarFonts: String {
    case koreaYMJBold = "a영명조B"
    case notoSerifCJKRegular = "NotoSansCJKkr-Medium"
    case notoSerifCJKMedium = "NotoSansCJKkr-Regular"
    case notoSerifCJKBold = "NotoSansCJKkr-Bold"

}

extension UIFont {

    convenience init?(font: StarStarFonts, size: CGFloat) {
        self.init(name: font.rawValue, size: size)
    }
    
    static func font(_ font: StarStarFonts, size: CGFloat) -> UIFont {
        return UIFont.init(name: font.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }

}
