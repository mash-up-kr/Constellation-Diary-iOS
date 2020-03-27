//
//  MultiStepNavigationController.swift
//  StarStarDiary
//
//  Created by juhee on 2020/02/17.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit

class MultiStepNavigationController: UINavigationController {

    private let drawerHandleView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationViews()
        self.delegate = self
    }

    lazy var backItem = UIBarButtonItem(image: UIImage(named: "icBack24"),
                                   style: .plain,
                                   target: self,
                                   action: #selector(self.pop(_:)))
    
    lazy var closeItem = UIBarButtonItem(image: UIImage(named: "icClose24"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(self.dismiss(_:)))
    
    @objc private func pop(_ sender: UIBarButtonItem) {
        self.popViewController(animated: true)
    }

    @objc private func dismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    private func setupNavigationViews() {
        self.navigationBar.do {
            $0.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            $0.shadowImage = UIImage()
            $0.backgroundColor = UIColor.clear
            $0.tintColor = .black
        }
        self.drawerHandleView.do {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 1.5
            view.addSubview($0)

            $0.snp.makeConstraints { drawer in
                drawer.centerX.equalToSuperview()
                drawer.top.equalToSuperview().offset(20)
                drawer.width.equalTo(24)
                drawer.height.equalTo(3)
            }
        }
    }
    
}

extension MultiStepNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let leftButtonItem = self.viewControllers.first == viewController ? self.closeItem : self.backItem
        viewController.navigationItem.setLeftBarButton(leftButtonItem, animated: animated)
    }
    
}
