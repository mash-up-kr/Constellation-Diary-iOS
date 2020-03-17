//
//  DiarySelectMonthViewController.swift
//  StarStarDiary
//
//  Created by suhyun on 2020/03/16.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit

protocol DiraySelectMonthViewDelegate: class {
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
    
    private struct SectionItem {
        var year: Int
        var rows: [CellItem]
    }
    
    private struct CellItem {
        var month: Int
        var numOfDiary: Int
        var isCurrent: Bool = false
    }
    
    private enum MonthType: String, CaseIterable {
        case january
        case february
        case march
        case april
        case may
        case june
        case july
        case august
        case september
        case october
        case november
        case december
        
        var key: String {
            return self.rawValue
        }
    }
    
    // MARK: - Items
    
    private var items: [SectionItem] = []
    private weak var delegate: DiraySelectMonthViewDelegate?
    
    // MARK: - Init
    
    private func initLayout() {
        
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
    
    private func initView() {
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
    
    private func initButton() {
        goPreviousButton.do {
            $0.setImage(UIImage(named: "icUp24"), for: .normal)
        }
        goNextButton.do {
            $0.setImage(UIImage(named: "icDown24"), for: .normal)
        }
    }
    
    private func initCollectionView() {
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
    
    // MARK: - Life Cycle
    
    convenience init(current: Date, delegate: DiraySelectMonthViewDelegate?) {
        self.init()
        
        self.delegate = delegate
        
        // set items
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: current)
        let currentMonth = calendar.component(.month, from: current)
        
        for indexI in 0..<5 {
            var year = currentYear
            if indexI > 2 {
                year += indexI-2
            } else if indexI < 2 {
                if indexI == 0 {
                    year -= 2
                } else {
                    year -= 1
                }
            }

            var cellItems: [CellItem] = []
            for indexJ in 0..<12 {
                let isCurrent = (currentMonth == indexJ+1 && year == currentYear) ? true : false
                cellItems.append(CellItem(month: indexJ+1, numOfDiary: 0, isCurrent: isCurrent)) // test
            }
            let sectionItem = SectionItem(year: year, rows: cellItems)
            
            items.append(sectionItem)
        }
        
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
    
    // MARK: - APIs
    
    private func setDirayCount(currentYear: Int) {
        // api
        Provider.request(.diariesCount(year: currentYear), completion: { [weak self] (diariesCount: DiariesCountDto) in
            guard let self = self else { return }
            print(diariesCount)
            
            guard let diraiesDto = diariesCount.diaries else { return }
            
            for (indexI, section) in self.items.enumerated() {
                for (index, diraies) in diraiesDto.enumerated() where section.year == diraies.year {
                    self.items[indexI].rows[index].numOfDiary = diraies.countsInMonth![index]
                }
            }
            
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 2), at: .centeredVertically, animated: true)
            self.collectionView.reloadData()
        }) { error in
            print(error)
        }
    }
    
    // MARK: - Events
    
    @objc
    private func didClickedBackground(sender: AnyObject?) {
        print(#function)
        hideAnimation()
    }
    
    // MARK: - Animation
    
    private func showAnimation() {
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
    
    private func hideAnimation() {
        UIView.animate(withDuration: 0.25, animations: {

            self.contentsView.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(UIScreen.main.bounds.size.height)
            }

            self.view.layoutIfNeeded()
        }) { isFinished in
            self.dismiss(animated: false, completion: nil)
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension DiarySelectMonthViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // 현재로부터 2년 전, 현재, 현재로부터 2년 후 ex. 2018~2022
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerCell = collectionView.dequeueHeaderView(with: DiarySelectMonthCollectionViewHeaderView.self, for: indexPath) else {
            return UICollectionReusableView()
        }
        
        let title = String(format: "%d", items[indexPath.section].year)
        
        headerCell.bind(title: title)
        return headerCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(with: DiarySelectMonthCollectionViewCell.self, for: indexPath) else {
            return DiarySelectMonthCollectionViewCell()
        }
        
        let item = items[indexPath.section].rows[indexPath.row]
        cell.bind(title: String(format: "%d월", item.month), value: String(format: "%d", item.numOfDiary), isSelected: item.isCurrent)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.section].rows[indexPath.row]
        
        delegate?.didSelectedMonth(viewController: self, month: item.month, year: items[indexPath.section].year)
        hideAnimation()
    }
}
