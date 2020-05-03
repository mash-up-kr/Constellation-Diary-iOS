//
//  UIFont+.swift
//  StarStarDiary
//
//  Created by juhee on 2020/01/31.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit

enum StarStarFonts: String {
    case koreaYMJBold = "KoreanYMJB"
    case notoSerifCJKRegular = "NotoSansCJKkr-Regular"
    case notoSerifCJKMedium = "NotoSansCJKkr-Medium"
    case notoSerifCJKBold = "NotoSansCJKkr-Bold"
}

extension UIFont {
    
    static func font(_ font: StarStarFonts, size: CGFloat) -> UIFont {
        return UIFont.init(name: font.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }

}
