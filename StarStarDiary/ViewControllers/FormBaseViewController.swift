//
//  FormBaseViewController.swift
//  StarStarDiary
//
//  Created by juhee on 2020/03/15.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit

class FormBaseViewController: UIViewController {

    let titleLabel = UILabel()
    let nextButton = UIButton()
    
    var inputFormViews: [InputFormView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.inputFormViews.forEach {
            $0.endEditing(true)
        }
    }
    
    func setupAttributes() {
        view.do {
            $0.backgroundColor = .white
            $0.addSubview(titleLabel)
            $0.addSubview(nextButton)
        }
        
        titleLabel.do {
            $0.font = .font(.notoSerifCJKMedium, size: 26)
        }
    
        nextButton.do {
            $0.backgroundColor = .gray122
            $0.isEnabled = false
            $0.titleLabel?.font = .font(.notoSerifCJKMedium, size: 16)
            $0.layer.cornerRadius = 5
        }
        
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(64)
            $0.leading.equalToSuperview().offset(20)
        }
    
        nextButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func updateNextButton(enable: Bool) {
        nextButton.isEnabled = enable
        nextButton.backgroundColor = enable ? .navy3 : .gray122
    }
    
    private func setupViews() {
        self.setupAttributes()
        self.setupConstraints()
    }

}
