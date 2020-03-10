//
//  ConstellationSelectionViewController.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/01/12.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit

enum ConstellationSelectionViewType {
    case select
    case horoscope
    
    var buttonTitle: String {
        switch self {
        case .select:
            return "별별일기 시작하기"
        case .horoscope:
            return "별자리 운세보기"
        }
    }

    var message: String {
        switch self {
        case .select:
            return "당신의 별자리를 선택해 주세요"
        case .horoscope:
            return "원하는 별자리를 선택해 주세요"
        }
    }

}


final class ConstellationSelectionViewController: UIViewController {

    // MARK: - UI
    
    private let backgrounImageView = UIImageView()
    private let backgroundAlphaView = UIView()
    private let constellationCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then { $0.scrollDirection = .horizontal }
    )
    private let messageLabel = UILabel()
    private let startButton = UIButton()
    
    // MARK: - Properties
    
    private var type = ConstellationSelectionViewType.select
    private var constellations = Constellation.allCases
    private var currentConstellation: Constellation?
    private var horoscopes: [Constellation: HoroscopeDto] = [:]
    private lazy var fakeItemCount = self.constellations.count * 50
    
    private var isHeightSmall: Bool {
        return self.view.frame.height < 700
    }

    private var itemSize: CGSize {
        return isHeightSmall ? CGSize(width: 225, height: 335) : CGSize(width: 240, height: 357)
    }
    
    func bind(type: ConstellationSelectionViewType) {
        self.type = type
        
    }
    
    // MARK: - Life Cycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.currentToken != nil {
            currentConstellation = UserDefaults.constellation
        }
        setUpLayout()
        setUpAttribute()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToInitialItem()
    }
    
    func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        if self.type == .horoscope {
            let closeButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.close))
            closeButton.tintColor = .white
            navigationItem.setLeftBarButton(closeButton, animated: false)
        }
        navigationController?.navigationBar.do {
            $0.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            $0.shadowImage = UIImage()
            $0.backgroundColor = UIColor.clear
            $0.tintColor = .white
            $0.barStyle = .black
        }
    }
    
    @objc func close() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func scrollToInitialItem() {
        var initialIndexPath = IndexPath(item: fakeItemCount / 2, section: 0)
        if UserDefaults.currentToken != nil {
            let constellation = UserDefaults.constellation
            messageLabel.text = constellation.desc
            currentConstellation = constellation
            let item = constellations.firstIndex(of: constellation) ?? 0
            initialIndexPath.item = fakeItemCount / 2 + item
        }

        constellationCollectionView.performBatchUpdates(nil) { _ in
            self.constellationCollectionView.selectItem(at: initialIndexPath,
                                               animated: false,
                                               scrollPosition: .centeredHorizontally)
        }
    }
    
    private func select(constellation: Constellation) {
        UserDefaults.constellation = constellation
        Provider.request(.modifyConstellations(constellation: constellation.name), completion: { [weak self] (data: UserDto) in
            UserManager.share.login(with: data)
            if let self = self, self.type == .horoscope {
                DispatchQueue.main.async { [weak self] in
                    self?.navigateMainView()
                }
            }
        }, failure: { _ in
        })
    }
    
    private func navigateHoroscopeDetailView(with constellation: Constellation) {
        if let horoscope = self.horoscopes[constellation] {
            let detailView = HoroscopeDetailViewController()
            detailView.delegate = self
            detailView.bind(data: horoscope, type: .changeConstellation)
            self.present(detailView, animated: true, completion: nil)
        } else {
            Provider.request(.horoscopes(constellation: constellation.name, date: Date()), completion: { [weak self] (data: HoroscopeDto) in
                DispatchQueue.main.async { [weak self] in
                    self?.horoscopes[constellation] = data
                    let detailView = HoroscopeDetailViewController()
                    detailView.delegate = self
                    detailView.bind(data: data, type: .changeConstellation)
                    self?.present(detailView, animated: true, completion: nil)
                }
            }, failure: { _ in
                // TODO :- API Call
            })
        }
    }
    
    @objc private func didTapSelect(_ sender: UIButton) {
        guard let constellation = currentConstellation else { return }
        
        switch type {
        case .select:
            select(constellation: constellation)
        case .horoscope:
            navigateHoroscopeDetailView(with: constellation)
        }
    }

    private func navigateMainView() {
        guard let window = self.view.window else { return }
        let mainViewController = MainViewController()
        let navi = UINavigationController(rootViewController: mainViewController)
        
        UIView.transition(from: self.view,
                          to: navi.view,
                          duration: 0.3,
                          options: [.transitionCrossDissolve],
                          completion: { _ in
                            window.rootViewController = navi
                            window.makeKeyAndVisible()
                        })
    }
}

// MARK: - Layouts

extension ConstellationSelectionViewController {
    private func setUpLayout() {
        let safeArea = view.safeAreaLayoutGuide.snp
        view.do {
            $0.addSubview(backgrounImageView)
            $0.addSubview(backgroundAlphaView)
            $0.addSubview(constellationCollectionView)
            $0.addSubview(messageLabel)
            $0.addSubview(startButton)
        }
        
        backgrounImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backgroundAlphaView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        constellationCollectionView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(safeArea.top).offset(40)
            $0.top.equalTo(safeArea.top).offset(40).priority(.low)
            $0.top.equalTo(safeArea.top).offset(120).priority(.medium)
            $0.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(375)
            $0.height.equalTo(400).priority(.low)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(constellationCollectionView.snp.bottom).offset(20)
            $0.top.equalTo(constellationCollectionView.snp.bottom).offset(30).priority(.medium)
            $0.bottom.lessThanOrEqualTo(safeArea.bottom).inset(124)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.greaterThanOrEqualTo(62)
        }
        
        startButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.lessThanOrEqualTo(safeArea.bottom).inset(20)
            $0.bottom.equalTo(safeArea.bottom).inset(35)
            $0.height.equalTo(52)
        }
        messageLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        messageLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
    }
}

// MARK: - Attributes

extension ConstellationSelectionViewController {
    private func setUpAttribute() {
        backgrounImageView.do {
            $0.image = UIImage(named: "bgMain")
            $0.contentMode = .scaleAspectFill
        }
        
        backgroundAlphaView.do {
            $0.backgroundColor = UIColor(white: 0, alpha: 0.4)
        }

        constellationCollectionView.do {
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = false
            $0.clipsToBounds = false
            $0.dataSource = self
            $0.delegate = self
            $0.contentInsetAdjustmentBehavior = .always
            let flowLayout = ConstellationSelectionViewFlowLayout(itemSize: itemSize)
            $0.collectionViewLayout = flowLayout
            $0.register(type: ConstellationCell.self)
        }

        messageLabel.do {
            $0.text = type.message
            $0.font = UIFont.font(.notoSerifCJKRegular, size: 14)
            $0.textColor = UIColor.init(white: 1, alpha: 0.65)
            $0.textAlignment = .center
            $0.numberOfLines = 3
        }
        
        startButton.do {
            $0.titleLabel?.font = UIFont.font(.notoSerifCJKRegular, size: 16)
            $0.setTitle(type.buttonTitle, for: .normal)
            $0.backgroundColor = .white
            $0.setTitleColor(.black, for: .normal)
            $0.layer.cornerRadius = 5
            $0.addTarget(self, action: #selector(didTapSelect(_:)), for: .touchUpInside)
        }
    }

}

// MARK: - UICollectionViewDataSource

extension ConstellationSelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return fakeItemCount
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(with: ConstellationCell.self,
                                                            for: indexPath) else {
            return ConstellationCell()
        }
        
        let index = indexPath.item % constellations.count
        let constellation = constellations[index]
        cell.configure(constellation)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ConstellationSelectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        let index = indexPath.item % constellations.count
        let constellation = constellations[index]
        messageLabel.text = constellation.desc
        currentConstellation = constellation
        if let selectedCell = collectionView.cellForItem(at: indexPath) {
            selectedCell.isSelected = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }

}

extension ConstellationSelectionViewController: HoroscopeDetailViewDelegate {

    func horoscopeDeatilView(_ viewController: HoroscopeDetailViewController, didTap button: UIButton) {
        guard let constellation = self.currentConstellation else { return }
        self.select(constellation: constellation)
    }

}
