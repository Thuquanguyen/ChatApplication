//
//  SignInWithAccountVC.swift
//  YTeThongMinh
//
//  Created by Apple on 10/14/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import UIKit
import JGProgressHUD
import FirebaseAuth

class SignInWithAccountVC: UIViewController {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPass: UITextField!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    private var loginObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionRegister(_ sender: Any) {
        
        let vc = RegisterVC()
        vc.isBack = false
        self.push(vc)
    }
    
    @IBAction func actionSignIn(_ sender: Any) {
        
        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
        
        //        let checkLogin = UserDefaults.standard.bool(forKey: "login_check")
        //        let phone = UserDefaults.standard.string(forKey: "email")
        //        let pass = UserDefaults.standard.string(forKey: "password")
        //        if tfPhone.text == phone && tfPass.text == pass{
        //            indicatorView.isHidden = false
        //            indicatorView.startAnimating()
        //            if checkLogin {
        //                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
        //                    self.indicatorView.isHidden = true
        //                    self.indicatorView.stopAnimating()
        //                    let vc = HomeVC()
        //                    self.push(vc)
        //                }
        //
        //            }else{
        //                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
        //                    self.indicatorView.isHidden = true
        //                    self.indicatorView.stopAnimating()
        //                    let vc = HomeVC()
        //                    self.push(vc)
        //                }
        //            }
        //           }else{
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
        //                self.indicatorView.isHidden = true
        //                self.indicatorView.stopAnimating()
        //                let vc = EnterOTPVC()
        //                self.push(vc)
        //            }
        //            let alert = UIAlertController(title: "Warning", message: "Account or password is incorrect!\nPlease try again!", preferredStyle: UIAlertController.Style.alert)
        //            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        //            self.present(alert, animated: true, completion: nil)
        //           }
        loginButtonTapped()
    }
}

extension SignInWithAccountVC{
    func loginButtonTapped() {
        tfEmail.resignFirstResponder()
        tfPass.resignFirstResponder()
        
        guard let email = tfEmail.text, let password = tfPass.text,
              !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError(content: "Please enter all information to log in.")
            return
        }
        // Firebase Log In
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult, error in            
            guard let result = authResult, error == nil else {
                self?.alertUserLoginError(content: "Tài khoản hoặc mật khẩu không đúng! Vui lòng kiểm tra lại!")
                return
            }
            
            _ = result.user
            
            let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
            DatabaseManager.shared.getDataFor(path: safeEmail, completion: { result in
                switch result {
                case .success(let data):
                    guard let userData = data as? [String: Any],
                          let nickName = userData["nick_name"] as? String else {
                        return
                    }
                    UserDefaults.standard.set(nickName, forKey: "name")
                    
                case .failure(let error):
                    print("Failed to read data with error \(error)")
                }
            })
            
            UserDefaults.standard.set(email, forKey: "email")
            
//            let vc = ConversationsViewController()
//            self?.push(vc)
            let vc = HomeVC()
            self?.push(vc)
        })
    }
    
    func alertUserLoginError(content: String) {
        let alert = UIAlertController(title: "Thông báo",
                                      message: content,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"OK",
                                      style: .cancel, handler: nil))
        present(alert, animated: true)
    }

}

extension Notification.Name {
    /// Notificaiton  when user logs in
    static let didLogInNotification = Notification.Name("didLogInNotification")
}
