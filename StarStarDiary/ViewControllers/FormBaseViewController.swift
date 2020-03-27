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
    
    deinit {
        removeKeyboardObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.addKeyboardObserver()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.inputFormViews.forEach {
            $0.endEditing(true)
            $0.updateValidate()
        }
        self.touchesBegan()
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
    
    func keyboardWillAppear(frame: CGRect, withDuration: TimeInterval, curve: UIView.AnimationOptions) { }
    func touchesBegan() { }

}

private extension FormBaseViewController {
    
    @objc func keyboardWillAppear(notification: Notification) {
        guard let info = notification.userInfo else { return }
        guard let value: NSValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let newFrame = value.cgRectValue

        if let durationNumber = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber, let keyboardCurveNumber = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber {
            let duration = durationNumber.doubleValue
            let keyboardCurve = keyboardCurveNumber.uintValue
            self.keyboardWillAppear(frame: newFrame, withDuration: duration, curve: UIView.AnimationOptions(rawValue: keyboardCurve))
        } else {
            self.keyboardWillAppear(frame: newFrame, withDuration: 0.2, curve: .curveEaseInOut)
        }
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillAppear(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupViews() {
        self.setupAttributes()
        self.setupConstraints()
    }

}
