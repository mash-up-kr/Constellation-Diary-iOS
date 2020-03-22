//
//  WriteViewController.swift
//  StarStarDiary
//
//  Created by suhyun on 2019/11/23.
//  Copyright © 2019 mash-up. All rights reserved.
//

import UIKit
import SnapKit
import Then

/*
 * Wirte Diary ViewController
 */

typealias AddTargetType = (target: Any?, action: Selector, for: UIControl.Event)

final class WriteViewController: UIViewController {

    // MARK: - Private Property
    
    private var diary: DiaryDto?
    private var horoscope: HoroscopeDto?
    
    private let navigationView = BaseNavigationView(frame: .zero)
    private let headerView = UIView(frame: .zero)
    private let bodyView = UIView(frame: .zero)

    // headerView
    private let titleTextView = UITextView(frame: .zero)
    private let headerViewBottomLine = UIView(frame: .zero)

    // bodyView
    private let contentsTextView = UITextView(frame: .zero)
    private let titlePlaceHolderButton = UIButton(frame: .zero)
    private let contentsPlaceHolderButton = UIButton(frame: .zero)
    
    private let contentsPlaceHolder: String = "오늘의 이야기를 들려주세요."
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        initLayout()
        initNavigationView()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func bind(diary: DiaryDto, isEditable: Bool) {
        self.diary = diary
        self.titleTextView.do {
            $0.text = diary.title
            $0.isUserInteractionEnabled = isEditable
        }
        self.contentsTextView.do {
            $0.text = diary.content
            $0.isUserInteractionEnabled = isEditable
        }
        self.titlePlaceHolderButton.do {
            $0.isHidden = true
            $0.isUserInteractionEnabled = isEditable
        }
        self.contentsPlaceHolderButton.do {
            $0.isHidden = true
            $0.isUserInteractionEnabled = isEditable
        }
    }
    
    func bind(horoscope: HoroscopeDto) {
        self.horoscope = horoscope
        let subRightTargetType: AddTargetType = (self, #selector(showHoroscope(sender:)), .touchUpInside)
        navigationView.setButton(type: .subRight, image: UIImage(named: "horoscope24"), addTargetType: subRightTargetType)
    }

}

extension WriteViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty == false {
            navigationView.button(for: .right).isEnabled = true
        } else {
           navigationView.button(for: .right).isEnabled = false
       }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == self.titleTextView {
            textView.snp.updateConstraints {
                $0.height.equalTo(textView.contentSize.height)
            }
            return self.titleTextView.text.count < 30
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            let placeHolderButton = textView == self.titleTextView ? self.titlePlaceHolderButton : self.contentsPlaceHolderButton
            placeHolderButton.isHidden = false
        }
    }

}

private extension WriteViewController {

    // MARK: - Event
    @objc
    func didTap(_ sender: UIButton) {
        let textView = sender == self.titlePlaceHolderButton ? self.titleTextView : self.contentsTextView
        sender.isHidden = true
        textView.becomeFirstResponder()
    }
    
    @objc
    func close(sender: AnyObject?) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func done(sender: AnyObject?) {
        guard let horoscopeId = self.diary?.horoscopeId ?? self.horoscope?.id,
            let title = titleTextView.text,
            let contents = contentsTextView.text
        else { return }
        
        var api = DiaryAPI.writeDiary(content: contents, horoscopeId: horoscopeId, title: title)
        if let diaryId = self.diary?.id {
            api = DiaryAPI.modifyDiary(id: diaryId, content: contents, title: title)
        }
        Provider.request(api, completion: { [weak self] (data: DiaryDto) in
                            _ = self?.navigationController?.viewControllers
                                .map { ($0 as? MainViewController)?.bind(diary: data) }
                            self?.navigationController?.popViewController(animated: true)
        })
    }

    @objc
    func showHoroscope(sender: AnyObject?) {
        let horoscopeViewController = HoroscopeDetailViewController()
        if let horoscope = self.horoscope {
            horoscopeViewController.bind(data: horoscope, type: .detail)
            navigationController?.present(horoscopeViewController, animated: true, completion: nil)
            return
        }
        
        guard let horoscopeId = self.diary?.horoscopeId else { return }
        Provider.request(DiaryAPI.horoscope(id: horoscopeId), completion: { [weak self] (data: HoroscopeDto) in
            guard let self = self else { return }
            horoscopeViewController.bind(data: data, type: .detail)
            self.navigationController?.present(horoscopeViewController, animated: true, completion: nil)
        })
    }

    // MARK: - Init
    
    func initViews() {
        view.do {
            $0.addSubview(navigationView)
            $0.addSubview(headerView)
            $0.addSubview(bodyView)
            $0.backgroundColor = .white
        }
        headerView.do {
            $0.addSubview(titleTextView)
            $0.addSubview(headerViewBottomLine)
            $0.addSubview(titlePlaceHolderButton)
        }
        
        bodyView.do {
            $0.addSubview(contentsTextView)
            $0.addSubview(contentsPlaceHolderButton)
        }
        headerViewBottomLine.backgroundColor = .white216
        titleTextView.do {
            $0.font = UIFont.font(.koreaYMJBold, size: 20)
            $0.delegate = self
            $0.contentOffset.y = 20
        }

        titlePlaceHolderButton.do {
            $0.titleLabel?.font =  UIFont.font(.koreaYMJBold, size: 20)
            $0.setTitle("제목", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.contentVerticalAlignment = .top
            $0.contentHorizontalAlignment = .leading
            $0.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
        }
        
        contentsTextView.do {
            let style = NSMutableParagraphStyle()
            style.minimumLineHeight = 23
            let attributes = [NSAttributedString.Key.paragraphStyle : style]
            $0.attributedText = NSAttributedString(string: $0.text, attributes: attributes)
            $0.font = UIFont.font(.notoSerifCJKRegular, size: 16)
            $0.delegate = self
        }
        
        contentsPlaceHolderButton.do {
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            $0.setTitle(contentsPlaceHolder, for: .normal)
            $0.setTitleColor(.gray114, for: .normal)
            $0.contentVerticalAlignment = .top
            $0.contentHorizontalAlignment = .leading
            $0.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
        }
    }

    func initLayout() {
        navigationView.snp.makeConstraints {
            $0.height.equalTo(44.0)
            $0.top.equalTo(view.snp.topMargin)
            $0.leading.trailing.equalToSuperview()
        }

        headerView.snp.makeConstraints {
            $0.height.equalTo(69.0)
            $0.top.equalTo(navigationView.snp.bottom)
            $0.trailing.leading.equalToSuperview()
        }

        titleTextView.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview()
            $0.height.equalTo(30)
            $0.bottom.equalToSuperview().inset(4.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
        }
        
        titlePlaceHolderButton.snp.makeConstraints {
            $0.edges.equalTo(titleTextView)
        }
        
        headerViewBottomLine.snp.makeConstraints {
            $0.height.equalTo(1.0)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(titleTextView)
        }
        
        bodyView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.trailing.equalTo(headerView.snp.trailing)
            $0.leading.equalTo(headerView.snp.leading)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
        }
        
        contentsTextView.snp.makeConstraints {
            $0.top.equalTo(bodyView.snp.top).offset(24.0)
            $0.trailing.equalTo(titleTextView.snp.trailing)
            $0.leading.equalTo(titleTextView.snp.leading)
            $0.bottom.equalTo(bodyView.snp.bottom)
        }
        
        contentsPlaceHolderButton.snp.makeConstraints {
            $0.edges.equalTo(contentsTextView)
        }
    }
    
    func initNavigationView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let leftTargetType: AddTargetType = (self, #selector(close(sender:)), .touchUpInside)
        let rightTargetType: AddTargetType = (self, #selector(done(sender:)), .touchUpInside)
        
        navigationView.setBackgroundColor(color: .clear) // test
        navigationView.setTitle(title: "일기 작성하기", titleColor: .black)
        navigationView.setButton(type: .left, image: UIImage(named: "icClose24"), addTargetType: leftTargetType)
        let completeButton = navigationView.setButton(type: .right, title: "완료", color: .buttonBlue, addTargetType: rightTargetType)
        completeButton.do {
            $0.isEnabled = false
        }
    }

}
