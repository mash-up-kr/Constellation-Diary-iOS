//
//  SettingsViewController.swift
//  StarStarDiary
//
//  Created by Karen on 2019/12/18.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var navigationView: BaseNavigationView!

    // MARK: - Event

    @objc
    private func onClose(sender: AnyObject?) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Init

    private func initNavigationView() {
        let leftTargetType: AddTargetType = (self, #selector(onClose(sender:)), .touchUpInside)

        navigationView.setBtnLeft(image: UIImage(named: "close"), addTargetType: leftTargetType)
        navigationView.setTitle(title: "설정", titleColor: .black, image: nil)
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initNavigationView()
    }
}
