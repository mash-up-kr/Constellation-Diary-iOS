//
//  Constellation.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/01/12.
//  Copyright © 2020 mash-up. All rights reserved.
//
import UIKit

enum Constellation: CaseIterable {
    
    case  aries
    case  taurus
    case  gemini
    case  cancer
    case  leo
    case  virgo
    case  libra
    case  scorpio
    case  sagittarius
    case  capricorn
    case  aquarius
    case  pisces
    
    var name: String {
        switch self {
        case .aries: return "양자리"
        case .taurus: return "황소자리"
        case .gemini: return "쌍둥이자리"
        case .cancer: return "게자리"
        case .leo: return "사자자리"
        case .virgo: return "처녀자리"
        case .libra: return "천칭자리"
        case .scorpio: return "전갈자리"
        case .sagittarius: return "궁수자리"
        case .capricorn: return "염소자리"
        case .aquarius: return "물병자리"
        case .pisces: return "물고기 자리"
        }
    }
    
    var date: String {
        switch self {
        case .aries: return "March 21 ~ April 19"
        case .taurus: return "April 20 ~ May 20"
        case .gemini: return "May 21 ~June 21"
        case .cancer: return "June 22 ~July 22"
        case .leo: return "July 23 ~ August 22"
        case .virgo: return "August 23 ~ September 22"
        case .libra : return "September 23 ~ October 23"
        case .scorpio: return "October 24 ~ November 21"
        case .sagittarius: return "November 22 ~ December 21"
        case .capricorn: return "December 22 ~ January 19"
        case .aquarius: return "January 20 ~ February 18"
        case .pisces: return "February 19 ~ March 20"
        }
    }
}
