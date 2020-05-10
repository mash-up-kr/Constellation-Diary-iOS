//
//  SettingDeveloperInfoViewController.swift
//  StarStarDiary
//
//  Created by juhee on 2020/04/25.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit
import SnapKit

final class SettingDeveloperInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationView()
    }
    
    @IBOutlet private var navigationView: BaseNavigationView?
    
    static func loadView() -> SettingDeveloperInfoViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return (storyboard.instantiateViewController(withIdentifier: "SettingDeveloperInfoViewController") as? SettingDeveloperInfoViewController) ?? SettingDeveloperInfoViewController()
    }
}

private extension SettingDeveloperInfoViewController {
    
    func setupNavigationView() {
        let leftTargetType: AddTargetType = (self, #selector(onClose(sender:)), .touchUpInside)

        navigationView?.do {
            $0.setBackgroundColor(color: .clear)
            $0.setButton(type: .left, image: UIImage(named: "icBack24"), addTargetType: leftTargetType)
            $0.setTitle(title: "개발자 정보", titleColor: .black, font: UIFont.font(.koreaYMJBold, size: 20))
            $0.setBottomLine(isHidden: true)
        }
    }
    
    @objc func onClose(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
