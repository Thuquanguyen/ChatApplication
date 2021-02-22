//
//  ProfileVC.swift
//  ChatApplication-DEV
//
//  Created by Apple on 2/7/21.
//  Copyright © 2021 Rikkeisoft. All rights reserved.
//

import UIKit
import FirebaseAuth
import SDWebImage

class ProfileVC: UIViewController {

    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var naviBar: CustomNaviBar!
    {
        didSet{
            naviBar.title = "Thông tin cá nhân"
        }
    }
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    var data = [ProfileViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageAvatar.setCorner(imageAvatar.bounds.width/2)
        initData()
        naviBar.buttonBack.didTap = {
            self.pop()
        }
    }

    @IBAction func actionLogout(_ sender: Any) {
        logout()
    }
}

extension ProfileVC{
    private func initData(){
        if let name = UserDefaults.standard.value(forKey:"name"), let email = UserDefaults.standard.value(forKey:"email"){
            labelName.text = "Tên đăng nhập : \(name)"
            labelEmail.text = "Email :\(email)"
        }
        fillImageAvatar()
    }
    
    private func logout(){
        UserDefaults.standard.setValue(nil, forKey: "email")
        UserDefaults.standard.setValue(nil, forKey: "name")
        do {
            try FirebaseAuth.Auth.auth().signOut()

            let vc = SignInWithAccountVC()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
        catch {
            print("Failed to log out")
        }
    }
    
    func fillImageAvatar(){
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let filename = safeEmail + "_profile_picture.png"
        let path = "images/"+filename

        StorageManager.shared.downloadURL(for: path, completion: { result in
            switch result {
            case .success(let url):
                self.imageAvatar.sd_setImage(with: url, completed: nil)
            case .failure(let error):
                print("Failed to get download url: \(error)")
            }
        })
    }
}
