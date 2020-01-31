//
//  UIView+.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/01/31.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit

extension UIView {
    func addSubview(_ subviewOrNil: UIView?) {
        if let subview = subviewOrNil {
            self.addSubview(subview)
        }
    }
}
