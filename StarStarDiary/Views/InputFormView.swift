//
//  InputCell.swift
//  StarStarDiary
//
//  Created by 이동영 on 2020/01/15.
//  Copyright © 2020 mash-up. All rights reserved.
//

import UIKit
import SnapKit
import Then

protocol InputFormViewDelegate: class {
    func inputFormView(_ inputFormView: InputFormView, didTimerEnded style: InputFormViewStyle)
    func inputFormView(_ inputFormView: InputFormView, didChanged text: String?)
    func inputFormView(_ inputFormView: InputFormView, didTap button: UIButton)
}

final class InputFormView: UIView {
    
    // MARK: - UI
    weak var delegate: InputFormViewDelegate?
    
    var inputText: String? {
        return self.inputTextField.text
    }
    
    let titleLabel = UILabel()
    let actionButton: UIButton = UIButton(type: .system)
    let lineView: UIView = UIView().then { $0.backgroundColor = .white216 }
    let inputTextField = UITextField()
    
    private let verificationImageView: UIImageView = UIImageView()
    private let messageLabel: UILabel = UILabel()
    private let timerLabel: UILabel = UILabel()
    
    var verified: Bool = false {
        didSet {
            let newValue = self.verified
            self.actionButton.isEnabled = newValue
            self.messageLabel.text = newValue ? "" : style.invalidMessage
            
            let color = newValue ? self.enableColor : self.disabledColor
            self.actionButton.backgroundColor = color
            self.lineView.backgroundColor = color
        }
    }
    private var style: InputFormViewStyle = .email
    
    private var startDate: Date?
    private var timer: Timer?
    private var duration: TimeInterval = .zero
    
    private let disabledColor = UIColor.white216
    private let enableColor = UIColor.buttonBlue
    private let errorColor = UIColor.coral255
    
    // MARK: - Initialization
    
    convenience init(frame: CGRect = .zero, style: InputFormViewStyle) {
        self.init(frame: frame)
        
        self.style = style
        configure(style: style)
        setupLayout()
        setupAttribute()
    }
    
    func configure(style: InputFormViewStyle) {
        titleLabel.text = style.title
        inputTextField.placeholder = style.placeHolder
        inputTextField.isSecureTextEntry = style.isSecureTextEntry
    }
    
    func startTimer(duration timeInterval: TimeInterval) {
        startDate = Date()
        self.duration = timeInterval
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        self.timerLabel.text = ""
        self.timerLabel.isHidden = false
    }

    func stopTimer() {
        resetTimer()
    }
    
    func checkValidate() {
        guard self.style.checksValidate == true, let inputText = self.inputText else { return }
        self.verified = self.style.isValid(inputText)
    }
    
}

private extension InputFormView {
    
    func resetTimer() {
        self.timer?.invalidate()
        self.timer = nil
        self.startDate = nil
        self.duration = .zero
    }
    
    @objc func update() {
        guard let startDate = startDate else {
            self.resetTimer()
            return
        }
        let endDate = startDate.advanced(by: duration)
        let distance = Date().distance(to: endDate)
        if distance <= 0 {
            self.resetTimer()
            self.delegate?.inputFormView(self, didTimerEnded: self.style)
            return
        } else {
            let seconds = Int(distance.truncatingRemainder(dividingBy: 60))
            let minutes = Int(distance / 60)
            self.timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    @objc func didEditingEndOnExit(_ textField: UITextField) {
        if let text = textField.text, style.checksValidate {
            self.verified = style.isValid(text)
        }
        self.delegate?.inputFormView(self, didChanged: textField.text)
    }
    
    @objc func didEditingChanged(_ textField: UITextField) {
        self.lineView.backgroundColor = textField.isEditing ? self.enableColor : self.disabledColor
        self.delegate?.inputFormView(self, didChanged: textField.text)
    }
    
    @objc func didTapActionButton(_ button: UIButton) {
        self.delegate?.inputFormView(self, didTap: button)
    }
    
    func setupLayout() {
        self.do {
            $0.addSubview(titleLabel)
            $0.addSubview(inputTextField)
            $0.addSubview(timerLabel)
            $0.addSubview(verificationImageView)
            $0.addSubview(actionButton)
            $0.addSubview(lineView)
            $0.addSubview(messageLabel)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        timerLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
            $0.top.bottom.equalTo(titleLabel)
        }
        
        inputTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(actionButton.snp.leading).offset(8)
            $0.height.equalTo(35)
        }
        
        verificationImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(32)
            $0.height.equalTo(32)
        }
        
        actionButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(1)
            $0.bottom.equalTo(lineView).inset(12)
            $0.width.equalTo(86)
            $0.height.equalTo(32)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(inputTextField.snp.bottom).offset(2)
            $0.leading.equalTo(inputTextField)
            $0.bottom.equalToSuperview()
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(inputTextField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(15)
        }
    }
    
    // MARK: - Attributes
    
    func setupAttribute() {
        titleLabel.do {
            $0.font = .font(.notoSerifCJKMedium, size: 12)
            $0.textColor = .black
        }
        
        inputTextField.do {
            $0.textColor = .black
            $0.font = .font(.notoSerifCJKMedium, size: 18)
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
            $0.spellCheckingType = .no
            $0.addTarget(self, action: #selector(didEditingEndOnExit), for: .editingDidEndOnExit)
            $0.addTarget(self, action: #selector(didEditingChanged), for: .editingDidBegin)
            $0.addTarget(self, action: #selector(didEditingChanged), for: .editingDidEnd)
            $0.addTarget(self, action: #selector(didEditingChanged), for: .editingChanged)
        }
        
        timerLabel.do {
            $0.textColor = .coral255
            $0.font = .font(.notoSerifCJKMedium, size: 10)
            $0.isHidden = true
        }
        
        verificationImageView.do {
            $0.backgroundColor = .buttonBlue
            $0.layer.cornerRadius = 16
            $0.contentMode = .center
            $0.isHidden = true
            $0.image = #imageLiteral(resourceName: "icComplete24White")
        }
        
        actionButton.do {
            $0.layer.cornerRadius = 16
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .gray122
            $0.titleLabel?.font = .font(.notoSerifCJKBold, size: 11)
            $0.isEnabled = false
            $0.isHidden = true
            $0.addTarget(self, action: #selector(didTapActionButton(_:)), for: .touchUpInside)
        }
        
        messageLabel.do {
            $0.textColor = errorColor
            $0.font = .font(.notoSerifCJKMedium, size: 10)
        }
    }
}

// MARK: - Style

enum InputFormViewStyle {
    case id
    case signUpPassword
    case signInPassword
    case resetPassword
    case confirmPassword
    case email
    case certificationNumber
    case findID
    
    var title: String {
        switch self {
        case .id: return "아이디"
        case .signUpPassword, .signInPassword: return "비밀번호"
        case .confirmPassword: return "비밀번호 확인"
        case .email, .findID: return "이메일"
        case .certificationNumber: return "인증번호"
        case .resetPassword: return "새로운 비밀번호"
        }
    }
    
    var placeHolder: String {
        switch self {
        case .id, .email, .findID, .certificationNumber: return "\(self.title) 입력"
        case .signUpPassword, .signInPassword, .confirmPassword: return "비밀번호 입력"
        case .resetPassword: return "새로운 비밀번호 입력"
        }
    }
    
    var invalidMessage: String? {
        switch self {
        case .id: return "아이디를 입력하세요."
        case .signUpPassword, .resetPassword: return "비밀번호는 영문자 숫자를 포함한 6~12 글자여야 합니다."
        case .confirmPassword: return "비밀번호 불일치"
        case .signInPassword: return "아이디/비밀번호가 맞지 않습니다."
        case .email: return "유효하지 않은 이메일"
        case .certificationNumber: return "인증번호 오류"
        case .findID: return "아이디를 찾을 수 없습니다."
        }
    }
    
    var checksValidate: Bool {
        switch self {
        case .id, .email, .findID, .signUpPassword, .resetPassword: return true
        case .signInPassword, .confirmPassword, .certificationNumber: return false
        }
    }
    
    var isSecureTextEntry: Bool {
        switch self {
        case .id, .email, .findID, .certificationNumber: return false
        case .signInPassword, .signUpPassword, .confirmPassword, .resetPassword: return true
        }
    }
    
    func isValid(_ input: String) -> Bool {
        switch self {
        case .id: return input.count >= 4
        case .signUpPassword, .resetPassword:
            let passRegEx = "[A-Za-z0-9]{6,12}"
            let passPred = NSPredicate(format:"SELF MATCHES %@", passRegEx)
            return passPred.evaluate(with: input)
        case .email, .findID:
           let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
           let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
           return emailPred.evaluate(with: input)
        case .signInPassword, .confirmPassword, .certificationNumber: return true
        }
    }

}
