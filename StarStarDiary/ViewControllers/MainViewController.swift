//
//  MainViewController.swift
//  StarStarDiary
//
//  Created by juhee on 2019/11/23.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit
import SnapKit


final class MainViewController: UIViewController {

    // MARK: - Properties

    private let writeDiaryLabel: UILabel       =       UILabel(frame: .zero)
    private let titleLabel: UILabel         =       UILabel(frame: .zero)
    private let editImageView: UIImageView  =       UIImageView(frame: .zero)
    private let horoscopeHeaderView: HoroscopeHeaderView = HoroscopeHeaderView(frame: .zero)
    private let backgroundImageView: UIImageView = UIImageView(frame: .zero)
    private var diary: DiaryDto?
    private var horoscope: HoroscopeDto?
    private let backgroundAlphaView = UIView()
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        requesthoroscope()
        registerObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigationBar()
    }
    
    func bind(questionDTO: DailyQuestionDto) {
        setTitle(questionDTO.question)
        if questionDTO.existDiary {
            Provider.request(DiaryAPI.diary(id: questionDTO.diaryId),
                             completion: { (data: DiaryDto) in
                                self.bind(diary: data)
                            })
        }
    }
    
    func bind(diary: DiaryDto) {
        self.diary = diary
        setTitle(diary.title)
    }
    
}

extension MainViewController: HoroscopeDetailViewDelegate {

    func horoscopeDeatilView(_ viewController: HoroscopeDetailViewController,
                           didTap button: UIButton,
                           with type: HoroscopeViewType) {
        didTapNewDiary()
    }

}

private extension MainViewController {
    
    func setTitle(_ text: String) {
         let attributedString = NSMutableAttributedString(string: text)
         let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0.31
        paragraphStyle.minimumLineHeight = 43
         attributedString.addAttribute(
             .paragraphStyle,
             value: paragraphStyle,
             range: NSRange(location: 0, length: attributedString.length
         ))
        self.titleLabel.attributedText = attributedString
    }
    
    func bind(horoscope: HoroscopeDto) {
        self.horoscope = horoscope
        horoscopeHeaderView.bind(horoscope: horoscope)
        horoscopeHeaderView.isHidden = false
    }
    
    func requesthoroscope() {
        Provider.request(DiaryAPI.horoscopes(constellation: UserDefaults.constellation.rawValue,
                                             date: Date().utc),
                                             completion: { (data: HoroscopeDto) in
                                                self.bind(horoscope: data)
                                            })
    }
    
    // MARK: actions
    
    @objc func openhoroscopeView() {
        guard let horoscope = self.horoscope else { return }
        let horoscopeViewController = HoroscopeDetailViewController()
        horoscopeViewController.bind(data: horoscope, viewType: .writeDirary)
        horoscopeViewController.delegate = self
        navigationController?.present(horoscopeViewController, animated: true, completion: nil)
    }

    @objc func didTapMenuItem() {
        let viewController = SideMenuViewController()
        viewController.modalPresentationStyle = .overFullScreen
        navigationController?.present(viewController, animated: false)
    }

    @objc func didTapStorageItem() {
        let viewController = DiaryListViewController()
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.present(viewController, animated: true)
    }

    @objc func didTapNewDiary() {
        let diaryViewController = WriteViewController()
        if let diary = self.diary {
            diaryViewController.bind(diary: diary)
        }
        if let horoscope = self.horoscope {
            diaryViewController.bind(horoscope: horoscope)
        }
        self.navigationController?.pushViewController(diaryViewController, animated: true)
    }
}

private extension MainViewController {

    func setupView() {
        view.backgroundColor = .black
        setupBackgroundImageView()
        setupBackgroundAlphaView()
        setupTitleLabel()
        setupWriteLabel()
        setuphoroscopeView()
        setupContainerView()
        setupGestures()
    }
    
    func setupBackgroundImageView() {
        backgroundImageView.do {
            $0.image = UIImage(named: "bg_main")
            $0.contentMode = .scaleAspectFill
            view.addSubview($0)
            $0.snp.makeConstraints { imageView in
                imageView.edges.equalToSuperview()
            }
        }
    }

    func setupNavigationBar() {
        let menuItem = UIBarButtonItem(image: UIImage(named: "icMenu24"),
                                       style: .plain,
                                       target: self,
                                       action: #selector(didTapMenuItem))
        navigationItem.setLeftBarButton(menuItem, animated: false)
        let storageItem = UIBarButtonItem(image: UIImage(named: "icBook24"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(didTapStorageItem))
        navigationItem.setRightBarButton(storageItem, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.do {
            $0.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            $0.shadowImage = UIImage()
            $0.backgroundColor = UIColor.clear
            $0.tintColor = .white
            $0.barStyle = .black
        }
        setupNavigationTitleView()
    }
    
    @objc func setupNavigationTitleView() {
        let logoImageView = UIImageView(image: UserDefaults.constellation.icon)
        logoImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = logoImageView
    }
    
    func setupTitleLabel() {
        titleLabel.do {
            $0.isUserInteractionEnabled = true
            $0.textColor = .white
            $0.font = UIFont.font(.koreaYMJBold, size: 30)
            $0.numberOfLines = 0
        }
    }
    
    func setupWriteLabel() {
        
        writeDiaryLabel.do {
            $0.font = UIFont.font(.notoSerifCJKMedium, size: 16)
            $0.text = "일기작성 >"
            $0.textColor = UIColor(white: 1, alpha: 0.7)
        }
    }
    
    func setuphoroscopeView() {
        horoscopeHeaderView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
            $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            $0.isUserInteractionEnabled = true
            $0.isHidden = true
            view.addSubview($0)

            $0.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        }
    }
    
    func setupBackgroundAlphaView() {
        
        backgroundAlphaView.do {
            $0.backgroundColor = UIColor(white: 0, alpha: 0.4)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }

    func setupContainerView() {
        let stackView = UIStackView()
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .leading
            $0.distribution = .equalSpacing
            $0.spacing = 25
            $0.addArrangedSubview(titleLabel)
            $0.addArrangedSubview(writeDiaryLabel)
            $0.isUserInteractionEnabled = true
            view.addSubview($0)
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapNewDiary))
            $0.addGestureRecognizer(recognizer)
            $0.isUserInteractionEnabled = true
        }

        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.snp.bottom).multipliedBy(0.2)
            $0.leading.equalToSuperview().inset(32.0)
        }
    }
    
    func setupGestures() {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(
            target: self,
            action: #selector(openhoroscopeView)
        )
        swipeGestureRecognizer.direction = .up
        view.addGestureRecognizer(swipeGestureRecognizer)
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(openhoroscopeView)
        )
        horoscopeHeaderView.addGestureRecognizer(tapGestureRecognizer)
    }

    func registerObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(setupNavigationTitleView), name: .didChangeConstellation, object: nil)
    }
}
