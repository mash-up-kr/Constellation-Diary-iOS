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
    
    private let navigationView = BaseNavigationView(frame: .zero)
    private let writeDiaryLabel = UILabel(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let editImageView = UIImageView(frame: .zero)
    private let horoscopeViewController = HoroscopeDetailViewController()
    private let lottieView = AnimationView()
    
    /// tutorial view
    private let tutorialView = UIView(frame: .zero)
    private let tutoArrowImageView = UIImageView(frame: .zero)
    private let tutoLabel = UILabel(frame: .zero)
    private let tutoStarImageView = UIImageView(frame: .zero)
    private let tutoCloseButton = UIButton(frame: .zero)
    
    private var horoscopeViewTopConstraints: NSLayoutConstraint?
    private var diary: DiaryDto?
    private var horoscope: HoroscopeDto?
    
    private var shouldOpenHoroscopeView: Bool = false
    private var gesture: UILongPressGestureRecognizer?
    
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
        
//        setupNavigationBar()
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
    
    @objc func didTapDiaryList() {
        let viewController = DiaryListViewController(horoscope: horoscope)
        viewController.do {
            let navigationController = UINavigationController.init(rootViewController: $0)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    @objc func didTouchView() {
        if let gesture = self.gesture {
            view.removeGestureRecognizer(gesture)
        }
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.tutorialView.alpha = 0.0
        }) { [weak self] isFinished in
            self?.tutorialView.isHidden = true
        }
    }
}

private extension MainViewController {
    
    func setupView() {
        view.backgroundColor = .black
        setupLottieView()
        setupTitleLabel()
        setupWriteLabel()
        setupContainerView()
        setupNavigationView()
        setupTutorialView()
        setuphoroscopeView()
        setupGestures()
        
        setupTutoContentsView()
    }
    
    func setupNavigationView() {
        navigationController?.setNavigationBarHidden(true, animated: false)

        navigationView.do {
            view.addSubview($0)
            setupNavigationTitleView()
            $0.setBackgroundColor(color: .clear)
            
            let leftTargetType: AddTargetType = (self,
                                                 #selector(didTapMenuItem),
                                                 .touchUpInside)
            
            $0.setButton(type: .left, image: UIImage(named: "icMenu24"), addTargetType: leftTargetType)
            $0.setButtonImageColor(type: .left, color: .white)
            
            let rightTargetType: AddTargetType = (self,
                                                  #selector(didTapDiaryList),
                                                  .touchUpInside)

            $0.setButton(type: .right, image: UIImage(named: "icBook24"), addTargetType: rightTargetType)
            $0.setButtonImageColor(type: .right, color: .white)
        }
        
        navigationView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44.0)
        }
    }
    
    @objc func setupNavigationTitleView() {
        navigationView.do {
            $0.setTitle(image: UserDefaults.constellation.icon, addTargetType: nil)
            $0.setButtonImageColor(type: .title, color: .white)
        }
    }
    
    func setupTutorialView() {
        
        UserDefaults.isFirstIn = false

        view.do {
            self.gesture = UILongPressGestureRecognizer(target: self, action: #selector(didTouchView))
            if let gesture = self.gesture {
                gesture.minimumPressDuration = 0.0
                $0.addGestureRecognizer(gesture)
            }
        }
        
        tutorialView.do {
            view.addSubview($0)
            $0.backgroundColor = .dim80
        }
        
        tutorialView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        // FIXME: - 서버 api 나오면 반영해야함.
        guard UserDefaults.isFirstIn == true else {
            tutorialView.isHidden = true
            return
        }
    }
    
    func setupTutoContentsView() {
        tutoArrowImageView.do {
            tutorialView.addSubview($0)
            $0.image = UIImage(named: "icMainArrow")
            $0.contentMode = .scaleAspectFit
        }
        
        tutoArrowImageView.snp.makeConstraints {
            $0.bottom.equalTo(horoscopeViewController.view.snp.top)
            $0.width.equalTo(48.0)
            $0.height.equalTo(72.0)
            $0.centerX.equalToSuperview()
        }
        
        tutoLabel.do {
            tutorialView.addSubview($0)
            $0.font = .systemFont(ofSize: 16.0)
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.textColor = .white
            $0.text = "검은색 바를 위로 올리면\n오늘의 별자리 운세를 볼 수 있어요!"
        }
        
        tutoLabel.snp.makeConstraints {
            $0.bottom.equalTo(tutoArrowImageView.snp.top).inset(-16.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48.0)
        }
        
        tutoStarImageView.do {
            tutorialView.addSubview($0)
            $0.image = UIImage(named: "icMainStar")
            $0.contentMode = .scaleAspectFit
        }
        
        tutoStarImageView.snp.makeConstraints {
            $0.bottom.equalTo(tutoLabel.snp.top).offset(-8.0)
            $0.width.height.equalTo(24.0)
            $0.centerX.equalToSuperview()
        }
        
        tutoCloseButton.do {
            tutorialView.addSubview($0)
            $0.setImage(UIImage(named: "iconMainClose"), for: .normal)
            $0.contentMode = .scaleAspectFit
        }
        
        tutoCloseButton.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.top).offset(10.0)
            $0.trailing.equalToSuperview().inset(18.0)
            $0.width.height.equalTo(24.0)
        }
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
    
//    func setupNavigationBar() {
//        let menuItem = UIBarButtonItem(image: UIImage(named: "icMenu24"),
//                                       style: .plain,
//                                       target: self,
//                                       action: #selector(didTapMenuItem))
//        navigationItem.setLeftBarButton(menuItem, animated: false)
//        navigationController?.setNavigationBarHidden(false, animated: false)
//        navigationController?.navigationBar.do {
//            $0.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//            $0.shadowImage = UIImage()
//            $0.backgroundColor = UIColor.clear
//            $0.tintColor = .white
//            $0.barStyle = .black
//            $0.layer.zPosition = 0
//        }
//        setupNavigationTitleView()
//    }
//
//    @objc func setupNavigationTitleView() {
//        let logoImageView = UIImageView(image: UserDefaults.constellation.icon)
//        logoImageView.contentMode = .scaleAspectFit
//        navigationItem.titleView = logoImageView
//    }
    
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
//        NotificationCenter.default.addObserver(self, selector: #selector(setupNavigationTitleView), name: .didChangeConstellation, object: nil)
    }
}
