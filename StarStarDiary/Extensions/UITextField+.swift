//
//  UITextField+.swift
//  StarStarDiary
//
//  Created by 이동영 on 2019/12/20.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit

extension UITextField {
    func underlined(with color: UIColor) {
        let border = CALayer()
        let width = CGFloat(1.0)
        
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0,
                              y: self.bounds.size.height - width,
                              width:  self.bounds.width,
                              height: self.bounds.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
