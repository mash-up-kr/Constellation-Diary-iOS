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
    case koreaYMJMedium = "KoreanYMJM"
    case koreaYMJE = "KoreanYMJE"
    case koreaYMJL = "KoreanYMJL"
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
