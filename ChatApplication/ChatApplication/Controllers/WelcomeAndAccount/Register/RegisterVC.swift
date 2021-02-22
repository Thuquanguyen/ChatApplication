//
//  RegisterVC.swift
//  YTeThongMinh
//
//  Created by Apple on 10/8/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterVC: UIViewController {
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageCheckBoxConfirm: UIImageView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var viewErrorEmail: UIView!
    @IBOutlet weak var viewErrorPhone: UIView!
    @IBOutlet weak var viewErrorPassWord: UIView!
    @IBOutlet weak var viewErrorConfirmPass: UIView!
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var labelErrorEmail: UILabel!
    @IBOutlet weak var labelErrorPhoneNumber: UILabel!
    @IBOutlet weak var labelErrorPassword: UILabel!
    @IBOutlet weak var labelErrorConfirmPass: UILabel!
    @IBOutlet weak var labelErrorConfirm: UILabel!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfNickName: UITextField!
    var isBack = true
    
    var isConfirm: Bool = false
    {
        didSet{
            imageCheckBoxConfirm.image = UIImage(named: isConfirm ? "icon_check" : "icon_uncheck")
        }
    }
    
    var year: Int = 0
    var isEmail = false,isPhone = false,isPass = false,isConfirmPass = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.isHidden = isBack
        btnCreateAccount.isUserInteractionEnabled = false
        indicatorView.isHidden = true
        initView()
        initTextField()
        imageAvatar.setCorner(imageAvatar.bounds.width/2)
        imageAvatar.addSingleTapGesture(target: self, selector: #selector(didTapChangeProfilePic))
    }
    
    @objc private func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func actionConfirm(_ sender: Any) {
        isConfirm = !isConfirm
        labelErrorConfirm.isHidden = isConfirm
        checkEnableButton()
    }
    
    @IBAction func actionSignIn(_ sender: Any) {
        let vc = SignInWithAccountVC()
        self.push(vc)
    }
    
    @IBAction func actionCreateAccount(_ sender: Any) {
//        indicatorView.isHidden = false
//        indicatorView.startAnimating()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            self.indicatorView.isHidden = true
//            self.indicatorView.stopAnimating()
////            let defaults = UserDefaults.standard
////            defaults.set(self.tfEmail.text, forKey: "email")
////            defaults.set(self.tfPassword.text, forKey: "password")
////            defaults.set(true, forKey: "register")
////            defaults.synchronize()
////            let vc = SignInWithAccountVC()
////            self.push(vc)
//            self.registerButtonTapped()
//        }
        self.registerButtonTapped()
    }
}

extension RegisterVC{
    func registerButtonTapped() {
        tfEmail.resignFirstResponder()
        tfPhone.resignFirstResponder()
        tfNickName.resignFirstResponder()
        tfPassword.resignFirstResponder()

        guard let nickName = tfNickName.text,
            let email = tfEmail.text,
            let password = tfPassword.text,
            let phoneNumber = tfPhone.text,
            !email.isEmpty,
            !password.isEmpty,
            !phoneNumber.isEmpty,
            !nickName.isEmpty else {
                return
        }
        // Firebase Log In

        DatabaseManager.shared.userExists(with: email, completion: { [weak self] exists in
            guard let strongSelf = self else {
                return
            }

            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { authResult, error in
                guard authResult != nil, error == nil else {
                    print("Error cureating user")
                    return
                }

                UserDefaults.standard.setValue(email, forKey: "email")
                UserDefaults.standard.setValue(nickName, forKey: "name")


                let chatUser = ChatAppUser(nickName: nickName,
                                          emailAddress: email)
                DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
                    if success {
                        // upload image
                        guard let image = strongSelf.imageAvatar.image,
                            let data = image.pngData() else {
                                return
                        }
                        let filename = chatUser.profilePictureFileName
                        StorageManager.shared.uploadProfilePicture(with: data, fileName: filename, completion: { result in
                            switch result {
                            case .success(let downloadUrl):
                                UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                print(downloadUrl)
                            case .failure(let error):
                                print("Storage maanger error: \(error)")
                            }
                        })
                    }
                })

                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    private func initView(){
        tableView.tableHeaderView = headerView
        let date = Date()
        year = Calendar.current.component(.year, from: date)
    }
    
    func initTextField(){
        tfEmail.addTarget(self, action: #selector(tfEmailDidChange(_:)), for: .editingChanged)
        tfPhone.addTarget(self, action: #selector(tfPhoneDidChange(_:)), for: .editingChanged)
        tfPassword.addTarget(self, action: #selector(tfPasswordDidChange(_:)), for: .editingChanged)
        tfNickName.addTarget(self, action: #selector(tfConfirmPassDidChange(_:)), for: .editingChanged)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    func checkShowErrorBirthDay(){
       
    }
    
    func checkEnableButton(){
        if isEmail && isPhone && isPass && isConfirm{
            btnCreateAccount.isEnabled = true
            btnCreateAccount.isUserInteractionEnabled = true
            labelErrorConfirmPass.isHidden = true
            btnCreateAccount.backgroundColor = UIColor("FF9800")
        }else{
            btnCreateAccount.isEnabled = false
            labelErrorConfirmPass.isHidden = false
            btnCreateAccount.isUserInteractionEnabled = false
            btnCreateAccount.backgroundColor = UIColor("03DAC5")
        }
    }
}

extension RegisterVC{
    @objc func tfEmailDidChange(_ textField: UITextField){
        if !isValidEmail(textField.text ?? "")
        {
            isEmail = false
            viewErrorEmail.isHidden = false
            labelErrorEmail.isHidden = false
        }else{
            isEmail = true
            viewErrorEmail.isHidden = true
            labelErrorEmail.isHidden = true
        }
        checkEnableButton()
    }
    
    @objc func tfPhoneDidChange(_ textField: UITextField){
        if textField.text?.count ?? 0 < 5 || textField.text?.count ?? 0 > 13{
            isPhone = false
            viewErrorPhone.isHidden = false
            labelErrorPhoneNumber.isHidden = false
        }else{
            isPhone = true
            viewErrorPhone.isHidden = true
            labelErrorPhoneNumber.isHidden = true
        }
        checkEnableButton()
    }
    
    @objc func tfPasswordDidChange(_ textField: UITextField){
        if textField.text?.count ?? 0 < 6{
            isPass = false
            viewErrorPassWord.isHidden = false
            labelErrorPassword.isHidden = false
        }else{
            isPass = true
            viewErrorPassWord.isHidden = true
            labelErrorPassword.isHidden = true
        }
        checkEnableButton()
    }
    
    @objc func tfConfirmPassDidChange(_ textField: UITextField){
        if textField.text != tfPassword.text{
            isConfirmPass = false
            viewErrorConfirmPass.isHidden = false
            labelErrorConfirmPass.isHidden = false
        }else{
            isConfirmPass = true
            viewErrorConfirmPass.isHidden = true
            labelErrorConfirmPass.isHidden = true
        }
        checkEnableButton()
    }
}

extension RegisterVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in

                                                self?.presentCamera()

        }))
        actionSheet.addAction(UIAlertAction(title: "Chose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in

                                                self?.presentPhotoPicker()

        }))

        present(actionSheet, animated: true)
    }

    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }

        self.imageAvatar.image = selectedImage
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
