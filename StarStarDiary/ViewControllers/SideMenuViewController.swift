//
//  SideMenuViewController.swift
//  StarStarDiary
//
//  Created by Karen on 2019/12/17.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {

    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var menuBackgroundView: UIView!
    @IBOutlet weak var constellationImageView: UIImageView!
    @IBOutlet weak var constellationTextLabel: UILabel!
    @IBOutlet weak var constellationDateLabel: UILabel!
    @IBOutlet weak var constellationButton: UIButton!
    @IBOutlet weak var diaryListButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!

    // MARK: - Animation

    public func show() {
        menuBackgroundView.frame.origin.x = -(UIScreen.main.bounds.width + menuBackgroundView.frame.width)

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimView.alpha = 1.0
            self.menuBackgroundView.frame.origin.x = .zero
        })
    }

    @objc
    private func hide() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn,
                       animations: { [weak self] in
            guard let self = self else { return }
            self.dimView.alpha = 0.0
            self.menuBackgroundView.frame.origin.x = -(UIScreen.main.bounds.width + self.menuBackgroundView.frame.width)
        }) { (isFinished) in
            self.dismiss(animated: false, completion: nil)
        }
    }

    // MARK: - Event

    @objc
    private func onSettingsViewController(sender: AnyObject?) {
        let viewController = UIStoryboard(name: "SettingsView", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController")
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
//        self.navigationController?.present(viewController, animated: true, completion: nil)
    }

    // MARK: - Init

    private func initView() {
        dimView.alpha = 0.0

        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        menuBackgroundView.backgroundColor = .white

        // FIXME: - 유저 데이터로 변경해야함
        constellationTextLabel.text = "처녀자리"
        constellationTextLabel.textAlignment = .center

        constellationDateLabel.text = "08.23 ~ 10.01"
        constellationDateLabel.textColor = .lightGray
        constellationDateLabel.adjustsFontSizeToFitWidth = true
        constellationDateLabel.textAlignment = .center

        constellationImageView.image = UIImage(named: "Virgo")
    }

    private func initBtn() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hide))
        self.view.addGestureRecognizer(tapGesture)

        constellationButton.setTitle("별자리", for: .normal)
        constellationButton.setTitleColor(.black, for: .normal)
        constellationButton.titleLabel?.textAlignment = .center

        diaryListButton.setTitle("보관함", for: .normal)
        diaryListButton.setTitleColor(.black, for: .normal)
        diaryListButton.titleLabel?.textAlignment = .center

        settingsButton.setTitle("설   정", for: .normal)
        settingsButton.setTitleColor(.black, for: .normal)
        settingsButton.titleLabel?.textAlignment = .center
        settingsButton.addTarget(self, action: #selector(onSettingsViewController(sender:)), for: .touchUpInside)
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initBtn()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        show()
    }
}
