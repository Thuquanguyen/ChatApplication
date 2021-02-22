//
//  RoomVC.swift
//  ChatApplication-DEV
//
//  Created by ThuNQ on 2/9/21.
//  Copyright © 2021 Rikkeisoft. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class RoomVC: UIViewController {

    @IBOutlet weak var naviBar: CustomNaviBar!{
        didSet{
            naviBar.title = "Group"
        }
    }
    
    @IBOutlet weak var messagesTable: UITableView!
    @IBOutlet weak var newMessageTextField: UITextField!
    
    public static let dateFormatter: DateFormatter = {
        let formattre = DateFormatter()
        formattre.dateStyle = .medium
        formattre.timeStyle = .long
        formattre.locale = .current
        return formattre
    }()
    var room:Room?
    var messages = [MessageModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naviBar.title = self.room?.name
        observerMessages()
        naviBar.buttonBack.didTap  = {
            self.pop()
        }
        messagesTable.registerNibCellFor(type: RoomCell.self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func actionSendMessage(_ sender: Any) {
        
        if let messageText = self.newMessageTextField.text{
            self.sendMessage(text: messageText, imageLink: nil)
        }
    }
    
    @IBAction func actionChoiceImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}

extension RoomVC{
    
    func sendMessage(text: String?, imageLink: String?){
        if let userId = Auth.auth().currentUser?.uid, let roomId = self.room?.roomId{
            
            let roomRef = Database.database().reference().child("rooms").child(roomId)
            let newMessageRef = roomRef.child("messages").childByAutoId()
            //   ServerValue.timestamp()
            let ref = Database.database().reference().child("users")
            ref.observeSingleEvent(of: .value) { (snapshot) in
                let userName = UserDefaults.standard.value(forKey: "name") as? String
                if(text != nil){
                    let messageData:[String: Any] = ["senderId": userId, "senderName" : userName ?? "", "text": text!, "date":ServerValue.timestamp()]
                    newMessageRef.updateChildValues(messageData)
                } else if(imageLink != nil){
                    let messageData:[String: Any] = ["senderId": userId, "senderName" : userName ?? "", "imageLink": imageLink!, "date":ServerValue.timestamp()]
                    newMessageRef.updateChildValues(messageData)
                }
                
                self.newMessageTextField.text = ""
                self.newMessageTextField.resignFirstResponder()
            }
        }
    }
    
    func observerMessages(){
        let messagesRef = Database.database().reference().child("rooms").child((self.room?.roomId)!).child("messages")
        
        messagesRef.observe(.childAdded) { (snapshot) in
            if let data = snapshot.value as? [String: Any] {
                if let senderId = data["senderId"] as? String, let senderName = data["senderName"] as? String{
                    var message:MessageModel?
                    
                    if let text = data["text"] as? String {
                        message = MessageModel(senderId: senderId, messageText: text, senderUsername: senderName, imageLink: nil)
                    } else if let imageLink = data["imageLink"] as? String{
                        message = MessageModel(senderId: senderId, messageText: nil, senderUsername: senderName, imageLink: imageLink)
                    }
                    if message != nil {
                        self.messages.append(message!)
                        self.messagesTable.reloadData()
                    }
                }
            }
        }
        
    }
}

extension RoomVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: RoomCell.self, for: indexPath)
        cell.selectionStyle = .none
        let message = self.messages[indexPath.row]
        if(Auth.auth().currentUser?.uid == message.senderId){
            cell.setBubbleType(type: .outgoing)
        } else {
            cell.setBubbleType(type: .incoming)
        }
        cell.setBubbleDataForMessage(message: message)
        return cell
    }
    
    private func createMessageId() -> String? {
        // date, otherUesrEmail, senderEmail, randomInt
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }

        let safeCurrentEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)
        let dateString = Self.dateFormatter.string(from: Date())
        let newIdentifier = "\(room?.roomId ?? "")_\(safeCurrentEmail)_\(dateString)"

        print("created message id: \(newIdentifier)")

        return newIdentifier
    }
}

extension RoomVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            selectedImage = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage{
            selectedImage = originalImage
        }
        
        if let _ = selectedImage {
            guard let messageId = createMessageId() else {
                    return
            }
            if let image = info[.editedImage] as? UIImage, let imageData =  image.pngData() {
                let fileName = "photo_group_message_" + messageId.replacingOccurrences(of: " ", with: "-") + ".png"

                // Upload image

                StorageManager.shared.uploadMessagePhoto(with: imageData, fileName: fileName, completion: { [weak self] result in

                    switch result {
                    case .success(let urlString):
                        print("Uploaded Message Photo: \(urlString)")

                        guard let url = URL(string: urlString) else {
                                return
                        }
                        self?.sendMessage(text: nil, imageLink: url.absoluteString)

                    case .failure(let error):
                        print("message photo upload error: \(error)")
                    }
                })
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
