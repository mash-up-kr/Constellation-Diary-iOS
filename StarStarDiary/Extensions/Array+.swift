//
//  Array+.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/02/09.
//  Copyright © 2020 mash-up. All rights reserved.
//

import Foundation

extension Array {
    
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }

}
