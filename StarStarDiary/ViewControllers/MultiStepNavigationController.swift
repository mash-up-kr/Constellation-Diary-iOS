//
//  MultiStepNavigationController.swift
//  StarStarDiary
//
//  Created by juhee on 2020/02/17.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit

class MultiStepNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        self.delegate = self
        // Do any additional setup after loading the view.
    }

    lazy var backItem = UIBarButtonItem(image: UIImage(named: "icBack24"),
                                   style: .plain,
                                   target: self,
                                   action: #selector(self.pop(_:)))
    
    lazy var closeItem = UIBarButtonItem(image: UIImage(named: "icClose24"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(self.dismiss(_:)))
    
    private func setupNavigationBar() {
        self.navigationBar.do {
            $0.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            $0.shadowImage = UIImage()
            $0.backgroundColor = UIColor.clear
            $0.tintColor = .black
        }
    }
    
    @objc private func pop(_ sender: UIBarButtonItem) {
        self.popViewController(animated: true)
    }

    @objc private func dismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
}

extension MultiStepNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.setRightBarButton(closeItem, animated: false)
        if self.viewControllers.first != viewController {
            viewController.navigationItem.setLeftBarButton(backItem, animated: false)
        }
    }
}
