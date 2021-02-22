//
//  HomeVC.swift
//  CreateUI
//
//  Created by ThuNQ on 10/13/20.
//  Copyright © 2020 ThuNQ. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var btnChatAdmin: UIButton!
    
    private var conversations = [Conversation]()
    private var loginObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let email = UserDefaults.standard.value(forKey: "email") as? String{
            let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
            if safeEmail == "adminkuchat-gmail-com"{
                btnChatAdmin.setTitle("Chat với nhân viên", for: .normal)
            }else{
                btnChatAdmin.setTitle("Chat với Admin", for: .normal)
            }
        }
        
        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.startListeningForCOnversations()
        })
    }
    
    @IBAction func actionChatAdmin(_ sender: Any) {
        if let email = UserDefaults.standard.value(forKey: "email") as? String{
            let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
            if safeEmail == "adminkuchat-gmail-com"{
                let vc = ConversationsViewController()
                self.push(vc)
            }else{
                didTapComposeButton()
            }
        }
    }
    
    @IBAction func actionChatGroup(_ sender: Any) {
        let vc = ConversationGroupVC()
        self.push(vc)
    }
    
    @IBAction func actionSetting(_ sender: Any) {
//        let vc = SettingVC()
//        self.push(vc)
    }
}

extension HomeVC{
    private func didTapComposeButton() {
        let currentConversations = conversations

        if let targetConversation = currentConversations.first(where: {
            $0.otherUserEmail == "adminkuchat-gmail-com"
        }) {
            let vc = ChatViewController(with: "adminkuchat-gmail-com", id: targetConversation.id)
            vc.isNewConversation = false
            vc.title = targetConversation.name
            vc.navigationItem.largeTitleDisplayMode = .never
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            self.createNewConversation()
        }
    }
    
    private func createNewConversation() {
        let name = "Admin Ku Chat"
        let email = "adminkuchat-gmail-com"

        // check in datbase if conversation with these two users exists
        // if it does, reuse conversation id
        // otherwise use existing code

        DatabaseManager.shared.conversationExists(iwth: email, completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let conversationId):
                let vc = ChatViewController(with: email, id: conversationId)
                vc.isNewConversation = false
                vc.title = name
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            case .failure(_):
                let vc = ChatViewController(with: email, id: nil)
                vc.isNewConversation = true
                vc.title = name
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
}

extension HomeVC {
    private func startListeningForCOnversations() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }

        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
        }

        print("starting conversation fetch...")

        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)

        DatabaseManager.shared.getAllConversations(for: safeEmail, completion: { [weak self] result in
            switch result {
            case .success(let conversations):
                print("successfully got conversation models")
                guard !conversations.isEmpty else {
                    return
                }
                self?.conversations = conversations
                self?.didTapComposeButton()
            case .failure(let error):
                print("failed to get convos: \(error)")
            }
        })
    }
}
