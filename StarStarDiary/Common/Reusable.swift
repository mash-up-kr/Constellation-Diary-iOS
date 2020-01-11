//
//  Reusable.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/01/12.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
}

// MARK: - Default Implementation

extension Reusable {
    static var reuseIdentifier: String { return String(describing: self) }
}
