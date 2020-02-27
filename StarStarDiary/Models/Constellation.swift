//
//  Constellation.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/01/12.
//  Copyright © 2020 mash-up. All rights reserved.
//
import UIKit

enum Constellation: String, CaseIterable {
    
    case aries = "양자리"
    case taurus = "황소자리"
    case gemini = "쌍둥이자리"
    case cancer = "게자리"
    case leo =  "사자자리"
    case virgo = "처녀자리"
    case libra = "천칭자리"
    case scorpio = "전갈자리"
    case sagittarius = "사수자리"
    case capricorn = "염소자리"
    case aquarius = "물병자리"
    case pisces = "물고기자리"
    
    var name: String {
        return self.rawValue
    }
    
    var date: String {
        switch self {
        case .aries: return "3.21 ~ 4.19"
        case .taurus: return "4.20 ~ 5.20"
        case .gemini: return "5.21 ~ 6.21"
        case .cancer: return "6.22 ~ 7.22"
        case .leo: return "7.23 ~ 8.22"
        case .virgo: return "8.23 ~ 9.23"
        case .libra : return "9.24 ~ 10.23"
        case .scorpio: return "10.24 ~ 11.22"
        case .sagittarius: return "11.23 ~ 12.24"
        case .capricorn: return "12.25 ~ 1.19"
        case .aquarius: return "1.20 ~ 2.18"
        case .pisces: return "2.19 ~ 3.20"
        }
    }
    
    var thumnail: UIImage? {
        switch self {
        case .aries: return UIImage(named: "thumbnailStarAries")
        case .taurus: return UIImage(named: "thumbnailStarTaurus")
        case .gemini: return UIImage(named: "thumbnailStarTwins")
        case .cancer: return UIImage(named: "thumbnailStarCancer")
        case .leo: return UIImage(named: "thumbnailStarLeo")
        case .virgo: return UIImage(named: "thumbnailStarVirgo")
        case .libra : return UIImage(named: "thumbnailStarLibra")
        case .scorpio: return UIImage(named: "thumbnailStarScorpio")
        case .sagittarius: return UIImage(named: "thumbnailStarSagittarius")
        case .capricorn: return UIImage(named: "thumbnailStarCapricorn")
        case .aquarius: return UIImage(named: "thumbnailStarAquarius")
        case .pisces: return UIImage(named: "thumbnailStarPisces")
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .aries: return UIImage(named: "icStarAries40White")
        case .taurus: return UIImage(named: "icStarTaurus40White")
        case .gemini: return UIImage(named: "icStarGemini40White")
        case .cancer: return UIImage(named: "icStarCancer40White")
        case .leo: return UIImage(named: "icStarLeo40White")
        case .virgo: return UIImage(named: "icStarVirgo40White")
        case .libra : return UIImage(named: "icStarLibra40White")
        case .scorpio: return UIImage(named: "icStarScorpio40White")
        case .sagittarius: return UIImage(named: "icStarSagittarius40White")
        case .capricorn: return UIImage(named: "icStarCapricorn40White")
        case .aquarius: return UIImage(named: "icStarAquarius40White")
        case .pisces: return UIImage(named: "icStarPisces40White")
        }
    }
    
    var iconBlack: UIImage? {
        switch self {
        case .aries: return UIImage(named: "icStarAries40")
        case .taurus: return UIImage(named: "icStarTaurus40")
        case .gemini: return UIImage(named: "icStarGemini40")
        case .cancer: return UIImage(named: "icStarCancer40")
        case .leo: return UIImage(named: "icStarLeo40")
        case .virgo: return UIImage(named: "icStarVirgo40")
        case .libra : return UIImage(named: "icStarLibra40")
        case .scorpio: return UIImage(named: "icStarScorpio40")
        case .sagittarius: return UIImage(named: "icStarSagittarius40")
        case .capricorn: return UIImage(named: "icStarCapricorn40")
        case .aquarius: return UIImage(named: "icStarAquarius40")
        case .pisces: return UIImage(named: "icStarPisces40")
        }
    }
    
    var desc: String {
        switch self {
        case .aries:
            return """
            양자리는 정의감이 있기 때문에 주변의 신뢰를 받으며
            거짓말을 잘 하지 못합니다. 차갑고 냉정한 면이 있지만
            속으로는 순수한 구석이 있습니다.
            """
        case .taurus:
        return """
            황소자리는 정이 많고 평화로운 성격을 가지고 있습니다.
            감정이나 기분 변화의 폭이 적고 안정적이기 때문에
            주변 사람들을 편안하게 해주는 장기가 있습니다.
            """
        case .gemini:
        return """
            쌍둥이자리는 연결고리를 찾는데 열중합니다.
            자신의 생각을 말로 표현하고자 하며,
            다양한 사람들과 관계를 형성하길 원합니다.
            """
        case .cancer:
            return """
            게자리의 감정 기복은 매우 심한 편입니다.
            애정이 깊고 감수성이 예민하기 때문에
            주변의 변화를 빠르게 눈치채는 편입니다.
            """
        case .leo:
            return """
            사자자리는 리더십이 있고 집중받는 것을 좋아합니다.
            다른 사람들을 끌어들이는  매력을 가지고 있습니다.
            사고방식이 복잡하지 않고 아이처럼 단순하기도 합니다.
            """
        case .virgo:
            return """
            처녀자리는 뛰어난 멀티플레이어입니다.
            한 번에 여러 가지 일을 능숙하게 해치우는 동시에
            여러 인간관계에서 중간 다리 역할을 하기도 합니다.
            """
        case .libra:
        return """
            천칭자리는 정이 많고 평화로운 성격을 가지고 있습니다.
            감정이나 기분 변화의 폭이 적고 안정적이기 때문에
            주변 사람들을 편안하게 해주는 장기가 있습니다.
            """
        case .scorpio:
        return """
            전갈자리는 비장한 구석이 있습니다.
            옳고 그름에 대한 신념이 있으며,
            정의감이 있기 때문에 주변의 신뢰를 받습니다.
        """
        case .sagittarius:
        return """
            사수자리는 현실보다는 자신의 이상을 추구하고,
            자유를 동경합니다. 낙관적인 의견을 가치있게 여기며,
            미지의 세계를 탐험하는 것을 좋아합니다.
        """
        case .capricorn:
        return """
            염소자리는  자기관리를 잘하며, 신중하게 표현합니다.
            힘들게 일해서 성취한 것을 가치있게 여깁니다.
            책임감이 투철하며, 자신의 의무를 잘 수행합니다.
        """
        case .aquarius:
        return """
            물병자리는 자유롭고 독창적인 사람을 꿈꿉니다.
            지성이 지배하는 인간적 세계를 희망하며,
            절대적으로 옳고 바른 것을 찾으려는 경향이 있습니다.
        """
        case .pisces:
        return """
            물고기자리는 정서적으로 민감하며,
            아낌없이 베풀 줄 아는 사람으로 인정받고 싶어합니다.
            타인의 상황이나 감정에 공감하는 능력이 뛰어납니다.
        """
        }
    }
}
