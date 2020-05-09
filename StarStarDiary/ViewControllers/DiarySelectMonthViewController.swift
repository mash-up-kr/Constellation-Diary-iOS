//
//  DiarySelectMonthViewController.swift
//  StarStarDiary
//
//  Created by suhyun on 2020/03/16.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit

protocol DiarySelectMonthViewDelegate: class {
    func didSelectedMonth(viewController: DiarySelectMonthViewController, month: Int, year: Int)
}

final class DiarySelectMonthViewController: UIViewController {
    
    private let baseView = UIView(frame: .zero)
    private let contentsView = UIView(frame: .zero)
    private let goPreviousButton = UIButton(frame: .zero)
    private let goNextButton = UIButton(frame: .zero)
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then { $0.scrollDirection = .horizontal }
    )
    
    // MARK: - Items
    
    private weak var delegate: DiarySelectMonthViewDelegate?
    private var yearlyDiaries: [YearlyDiary] = []
    private var date: Date = Date()
    
    
    // MARK: - Life Cycle
    
    convenience init(current: Date, delegate: DiarySelectMonthViewDelegate?) {
        self.init()
        self.date = current
        self.delegate = delegate
        
        // set items
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: current)
        
        setDirayCount(currentYear: currentYear)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
        initView()
        initButton()
        initCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showAnimation()
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension DiarySelectMonthViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.yearlyDiaries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerCell = collectionView.dequeueHeaderView(with: DiarySelectMonthCollectionViewHeaderView.self, for: indexPath) else {
            return UICollectionReusableView()
        }
        
        self.yearlyDiaries[safe: indexPath.section].map {
            headerCell.bind(title: "\($0.year)")
        }
        return headerCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(with: DiarySelectMonthCollectionViewCell.self, for: indexPath) else {
            return DiarySelectMonthCollectionViewCell()
        }
        if let monthlyDiary = self.yearlyDiaries[safe: indexPath.section]?.countsInMonth[safe: indexPath.item] {
            cell.bind(title: monthlyDiary.name, value: "\(monthlyDiary.count)")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let yearlyDiary = self.yearlyDiaries[safe: indexPath.section] else {
            return
        }
        
        delegate?.didSelectedMonth(viewController: self, month: indexPath.item + 1, year: yearlyDiary.year)
        hideAnimation()
    }
}


private extension DiarySelectMonthViewController {
    
    // MARK: - APIs
    
    func setDirayCount(currentYear: Int) {
        // api
        Provider.request(.diariesCount(year: currentYear), completion: { [weak self] (data: YearlyDiaryResponse) in
            guard let yearlyDiaries = data.diaries else {
                return
            }
            self?.yearlyDiaries = yearlyDiaries
            self?.reloadCollectionView(moveTo: currentYear)
        }) { error in
            print(error)
        }
    }
    
    func reloadCollectionView(moveTo year: Int) {
        let calendar = Calendar.current
        let indexPathItem = calendar.component(.month, from: self.date) - 1
        self.collectionView.reloadData()
        if let section = self.yearlyDiaries.firstIndex(where: { $0.year == year }) {
            let indexPath = IndexPath(item: indexPathItem, section: section)
            self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        }
    }
    
    // MARK: - Events
    
    @objc
    func didClickedBackground(sender: AnyObject?) {
        print(#function)
        hideAnimation()
    }
    
    // MARK: - Animation
    
    func showAnimation() {
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: { [weak self] in
            guard let self = self else { return }
            
            self.contentsView.snp.updateConstraints {
                $0.bottom.equalToSuperview().constraint.update(inset: 24.0)
            }
            
            self.view.layoutIfNeeded()
        }) { isFinished in
            //
        }
    }
    
    func hideAnimation() {
        UIView.animate(withDuration: 0.25, animations: {

            self.contentsView.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(UIScreen.main.bounds.size.height)
            }

            self.view.layoutIfNeeded()
        }) { isFinished in
            self.dismiss(animated: false, completion: nil)
        }
    }

    // MARK: - Init
    
    func initLayout() {
        
        view.addSubview(baseView)
        view.addSubview(contentsView)
        contentsView.addSubview(goPreviousButton)
        contentsView.addSubview(goNextButton)
        contentsView.addSubview(collectionView)
        
        baseView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        contentsView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24.0)
            $0.trailing.equalToSuperview().inset(24.0)
            $0.height.equalToSuperview().multipliedBy(0.6)
            $0.bottom.equalToSuperview() // .inset(24.0)
        }
        
        goPreviousButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8.0)
            $0.width.height.equalTo(24.0)
            $0.centerX.equalToSuperview()
        }
        
        goNextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(8.0)
            $0.width.height.equalTo(24.0)
            $0.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(goPreviousButton.snp.bottom)
            $0.bottom.equalTo(goNextButton.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
    }
    
    func initView() {
        view.backgroundColor = .clear
        
        contentsView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10.0
        }
        
        baseView.do {
            $0.backgroundColor = UIColor.dim

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didClickedBackground(sender:)))
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(tapGesture)
        }
    }
    
    func initButton() {
        goPreviousButton.do {
            $0.setImage(UIImage(named: "icUp24"), for: .normal)
        }
        goNextButton.do {
            $0.setImage(UIImage(named: "icDown24"), for: .normal)
        }
    }
    
    func initCollectionView() {
        collectionView.do {
            $0.backgroundColor = .white

            $0.dataSource = self
            $0.delegate = self
            
            $0.register(type: DiarySelectMonthCollectionViewCell.self)
            $0.registerHeaderView(type: DiarySelectMonthCollectionViewHeaderView.self)
            
            $0.contentInset = UIEdgeInsets(top: 0.0, left: 40.0, bottom: 0.0, right: 40.0)
            
            let layout = UICollectionViewFlowLayout()
            layout.headerReferenceSize = CGSize(width: collectionView.bounds.width, height: 48.0)
//            layout.estimatedItemSize = CGSize(width: collectionView.bounds.width/3, height: 24.0)
            layout.itemSize = CGSize(width: 70.0, height: 24.0)
            $0.collectionViewLayout = layout
        }
    }
}
