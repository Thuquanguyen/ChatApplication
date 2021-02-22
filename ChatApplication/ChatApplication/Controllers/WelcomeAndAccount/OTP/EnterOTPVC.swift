//
//  EnterOTPVC.swift
//  YTeThongMinh
//
//  Created by QuanNH on 5/28/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import UIKit

class EnterOTPVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textField0: UITextField!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textField5: UITextField!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonSendOTP: UIButton!
    
    @IBOutlet weak var captchaTextView: FillTextView!
    @IBOutlet weak var captchaTextViewHeightCS: NSLayoutConstraint!

    // MARK: - Properties
    var failedOtpAttemps: Int = 1
    var captcha = CaptchaGenerator()
    
    enum TypeVerifyOTP {
        case loginInactive
        case registerVerify
        case resetPassword
        
        func title() -> String {
            switch self {
            case .loginInactive:
                return "Tài khoản của bạn chưa được xác thực\nVui lòng nhập mã OTP được gửi đến số điện thoại "
            case .registerVerify:
                return "Vui lòng nhập mã gồm 6 chữ số\nđã được gửi đến điện thoại của bạn"
            case .resetPassword:
                return "Vui lòng nhập mã gồm 6 chữ số\nđã được gửi đến điện thoại của bạn"
            }
        }
    }
    var list: [UITextField] = []
    var loginName: String?
    var password: String?
    var phone: String?
    var typeOtp = TypeVerifyOTP.registerVerify
    var canSendOTP = true
    var countSendOTP = 120
    var text = ""
    
    static var timer: Timer?
    
    // MARK: - Closures
    var didPopToChangePhone: (()->Void)?
    
    deinit {
        print("Deinit \(self.name)")
        EnterOTPVC.timer?.invalidate()
        EnterOTPVC.timer = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        setCanSendOTP()
    }
    
    func setupVC() {
        textField.becomeFirstResponder()
        labelDescription.text = typeOtp.title()
        if typeOtp == .loginInactive {
            labelTitle.text = "Xác thực tài khoản"
            if let phone = self.phone {
                if phone.count >= 10 {
                    let prefix = phone.prefix(4)
                    let suffix = phone.suffix(3)
                    var mid = ""
                    for _ in 0..<(phone.count - 7) {
                        mid += "x"
                    }
                    let text = prefix + mid + suffix
                    labelDescription.text = typeOtp.title() + "\(text)"
                }
            }
        }
        textField0.becomeFirstResponder()
        list = [textField0, textField1, textField2, textField3, textField4, textField5]
        list.forEach { (textField) in
            textField.tintColor = .clear
            textField.keyboardType = .numberPad
        }
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        if text.count == 5 && sender.text?.count == 6 {
            let vc = HomeVC()
            self.push(vc)
        }
        text = sender.text ?? ""
        sender.text = String(text.prefix(6))
        for (index, item) in list.enumerated() {
            if text.count > index {
                item.text = String(text[index])
            } else {
                item.text = ""
            }
        }
    }
    
    @IBAction func buttonResendOTP(_ sender: Any) {
        if canSendOTP {
            setCanSendOTP()
        }
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        pop()
    }
    
    
    private func secondsToMinutesSeconds (seconds : Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func setCanSendOTP(){
        buttonSendOTP.isEnabled = false
        buttonSendOTP.backgroundColor = UIColor("A9D8E1")
        buttonSendOTP.alpha = 0.7
        countSendOTP = 120
        labelCount.text = "02:00"
        canSendOTP = false
        EnterOTPVC.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self]  (timer) in
            self?.countSendOTP -= 1
            if let count: Int = self?.countSendOTP {
                let (m,s) = self?.secondsToMinutesSeconds(seconds: count) ?? (0,0)
                let seconds = s < 10 ? "0\(s)" : "\(s)"
                self?.labelCount.text = "0\(m):\(seconds)"
                if count == 0 {
                    self?.buttonSendOTP.isEnabled = true
                    self?.buttonSendOTP.backgroundColor = UIColor("64D3D4")
                    self?.canSendOTP = true
                    EnterOTPVC.timer?.invalidate()
                    EnterOTPVC.timer = nil
                }
            }
        })
    }
}
