//
//  Constellation.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/01/12.
//  Copyright © 2020 mash-up. All rights reserved.
//
import UIKit

struct Constellation {
    let name: String
    let date: String
// TODO: - 추후 에셋 적용
//    let icon: UIImage
//    let image: UIImage
    
    init(_ name: String, _ date: String) {
        self.name = name
        self.date = date
    }
}

extension Constellation {
    static let aries = Constellation("양자리", "March 21 ~ April 19")
    static let taurus = Constellation("황소자리", "April 20 ~ May 20")
    static let gemini = Constellation("쌍둥이자리","May 21 ~June 21")
    static let cancer = Constellation("게자리", "June 22 ~July 22")
    static let leo = Constellation("사자자리", "July 23 ~ August 22")
    static let virgo = Constellation("처녀자리", "August 23 ~ September 22")
    static let libra = Constellation("천칭자리", "September 23 ~ October 23")
    static let scorpio = Constellation("전갈자리", "October 24 ~ November 21")
    static let sagittarius = Constellation("궁수자리", "November 22 ~ December 21")
    static let capricorn = Constellation("염소자리", "December 22 ~ January 19")
    static let aquarius = Constellation("물병자리", "January 20 ~ February 18")
    static let pisces = Constellation("물고기 자리", "February 19 ~ March 20")
    
    static let allCases = [aries,
                           taurus,
                           gemini,
                           cancer,
                           leo,
                           virgo,
                           libra,
                           scorpio,
                           sagittarius,
                           capricorn,
                           aquarius,
                           pisces]
}
