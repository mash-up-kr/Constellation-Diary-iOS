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
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Event

    @objc
    private func onClose(sender: AnyObject?) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Init

    private func initNavigationView() {
        let leftTargetType: AddTargetType = (self, #selector(onClose(sender:)), .touchUpInside)

        navigationView.do {
            $0.setBtnLeft(image: UIImage(named: "icClose24"), addTargetType: leftTargetType)
            $0.setTitle(title: "설정", titleColor: .black, image: nil)
        }
    }
    
    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initNavigationView()
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         // TODO: - 아이템 count 으로 변경 예정
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: - 아이템의 cellType에 따라 변경 예정
        return UITableViewCell()
    }
}
