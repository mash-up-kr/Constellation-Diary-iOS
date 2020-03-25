//
//  MainViewController.swift
//  StarStarDiary
//
//  Created by juhee on 2019/11/23.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit
import SnapKit
import Lottie


final class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private let writeDiaryLabel = UILabel(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let editImageView = UIImageView(frame: .zero)
    private let horoscopeViewController = HoroscopeDetailViewController()
    private let lottieView = AnimationView()
    
    private var horoscopeViewTopConstraints: NSLayoutConstraint?
    private var diary: DiaryDto?
    private var horoscope: HoroscopeDto?
    
    private var shouldOpenHoroscopeView: Bool = false
    
    // MARK: Life cycle
    
    convenience init(shouldOpenHoroscopeView: Bool = false) {
        self.init()
        
        self.shouldOpenHoroscopeView = shouldOpenHoroscopeView
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        requesthoroscope()
        registerObserver()
        if let dailyQuestion = UserManager.share.dailyQuestion {
            bind(questionDTO: dailyQuestion)
        } else {
            requestDailyQuestion()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
        lottieView.play()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldOpenHoroscopeView {
            openhoroscopeView()
        } else {
            self.horoscopeViewTopConstraints?.constant = self.horoscopeViewMaxY
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
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
                             didTap button: UIButton) {
        self.closeHoroscopeView()
        DispatchQueue.main.async {
            self.didTapNewDiary()
        }
    }
}

private extension MainViewController {
    
    var horoscopeViewMinY: CGFloat {
        return self.view.safeAreaInsets.top
    }
    
    var horoscopeViewMaxY: CGFloat {
        return self.view.frame.maxY - (self.view.safeAreaInsets.bottom + HoroscopeHeaderView.height)
    }
    
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
        self.titleLabel.sizeToFit()
    }
    
    func bind(horoscope: HoroscopeDto) {
        self.horoscope = horoscope
        horoscopeViewController.bind(data: horoscope, type: .writeDiary(diary: self.diary))
    }
    
    func requestDailyQuestion() {
        Provider.request(.dailyQuestions, completion: {[weak self] (data: DailyQuestionDto) in
            UserManager.share.updateDailyQuestion(with: data)
            self?.bind(questionDTO: data)
        })
    }
    
    func requesthoroscope() {
        Provider.request(DiaryAPI.horoscopes(constellation: UserDefaults.constellation.rawValue,
                                             date: Date()),
                         completion: { (data: HoroscopeDto) in
                            self.bind(horoscope: data)
        })
    }
    
    // MARK: actions
    
    @objc func openhoroscopeView() {
        self.horoscopeViewTopConstraints?.constant = self.horoscopeViewMinY
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func closeHoroscopeView() {
        self.horoscopeViewTopConstraints?.constant = self.horoscopeViewMaxY
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func didTapMenuItem() {
        let viewController = SideMenuViewController(horoscope: self.horoscope)
        viewController.modalPresentationStyle = .overFullScreen
        navigationController?.present(viewController, animated: false)
    }
    
    @objc func didTapNewDiary() {
        let diaryViewController = WriteViewController()
        if let diary = self.diary {
            diaryViewController.bind(diary: diary, isEditable: true)
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
        setupLottieView()
        setupTitleLabel()
        setupWriteLabel()
        setupContainerView()
        setuphoroscopeView()
        setupGestures()
    }
    
    func setupLottieView() {
        lottieView.do {
            $0.contentMode = .scaleAspectFill
            let animation = Animation.named("background")
            $0.animation = animation
            $0.backgroundBehavior = .pauseAndRestore
            $0.loopMode = .loop
            view.addSubview($0)
            $0.snp.makeConstraints { lottie in
                lottie.edges.equalToSuperview()
            }
        }
    }
    
    func setupNavigationBar() {
        let menuItem = UIBarButtonItem(image: UIImage(named: "icMenu24"),
                                       style: .plain,
                                       target: self,
                                       action: #selector(didTapMenuItem))
        navigationItem.setLeftBarButton(menuItem, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.do {
            $0.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            $0.shadowImage = UIImage()
            $0.backgroundColor = UIColor.clear
            $0.tintColor = .white
            $0.barStyle = .black
            $0.layer.zPosition = 0
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
        horoscopeViewController.do {
            self.addChild($0)
            self.modalPresentationStyle = .pageSheet
            $0.delegate = self
        }
        
        horoscopeViewController.view.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
            $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            $0.isUserInteractionEnabled = true
            $0.layer.zPosition = 1
            view.addSubview($0)
            
            $0.snp.makeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
            }
            horoscopeViewTopConstraints = $0.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.maxY)
            horoscopeViewTopConstraints?.isActive = true
        }
    }
    
    func setupContainerView() {
        let stackView = UIStackView()
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
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
        let upSwipeGestureRecognizer = UISwipeGestureRecognizer(
            target: self,
            action: #selector(openhoroscopeView)
        )
        upSwipeGestureRecognizer.direction = .up
        view.addGestureRecognizer(upSwipeGestureRecognizer)
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(openhoroscopeView)
        )
        horoscopeViewController.view.addGestureRecognizer(tapGestureRecognizer)
        let downSwipeGestureRecognizer = UISwipeGestureRecognizer(
            target: self,
            action: #selector(closeHoroscopeView)
        )
        downSwipeGestureRecognizer.direction = .down
        horoscopeViewController.view.addGestureRecognizer(downSwipeGestureRecognizer)
    }
    
    func registerObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(setupNavigationTitleView), name: .didChangeConstellation, object: nil)
    }
}
