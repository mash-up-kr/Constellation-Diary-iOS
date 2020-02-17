//
//  UIFont+.swift
//  StarStarDiary
//
//  Created by juhee on 2020/01/31.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit

enum StarStarFonts: String {
    case koreaYMJBold = "KoreanYMJ-B"
    case koreaYMJMedium = "KoreanYMJ-M"
    case koreaYMJE = "KoreanYMJ-E"
    case koreaYMJL = "KoreanYMJ-L"
    case notoSerifCJKRegular = "NotoSansCJKkr-Medium"
    case notoSerifCJKMedium = "NotoSansCJKkr-Regular"
    case notoSerifCJKBold = "NotoSansCJKkr-Bold"
    case nanumMyeongjoBold = "NanumMyeongjo-Bold"
}

extension UIFont {
    
    static func font(_ font: StarStarFonts, size: CGFloat) -> UIFont {
        return UIFont.init(name: font.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }

}
