//
//  ConversationGroupVC.swift
//  ChatApplication-DEV
//
//  Created by ThuNQ on 2/9/21.
//  Copyright © 2021 Rikkeisoft. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ConversationGroupVC: UIViewController {

    @IBOutlet weak var newRoomTextField: UITextField!
    @IBOutlet weak var chatRoomsTable: UITableView!
    @IBOutlet weak var stackCreateChat: UIStackView!
    
    @IBOutlet weak var naviBar: CustomNaviBar!{
        didSet{
            naviBar.title = "Group chat"
            naviBar.buttonBack.imageColor = .white
        }
    }
    
    var rooms = [Room]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.observeRooms()
        self.chatRoomsTable.registerNibCellFor(type: ConversationGroupCell.self)
        naviBar.buttonBack.didTap = {
            self.pop()
        }
        if let email = UserDefaults.standard.value(forKey: "email") as? String{
            let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
            if safeEmail == "adminkuchat-gmail-com"{
                stackCreateChat.isHidden = false
            }else{
                stackCreateChat.isHidden = true
            }
        }
    }
    
    @IBAction func actionCreateRoom(_ sender: Any) {
        guard let userId = Auth.auth().currentUser?.uid, let roomName = self.newRoomTextField.text, roomName.isEmpty == false else {
            return
        }
        self.newRoomTextField.resignFirstResponder()
        
        let databaseRef = Database.database().reference()
        let roomRef = databaseRef.child("rooms").childByAutoId()
        let roomData:[String: Any] = ["creatorId" : userId, "name": roomName]
        
        roomRef.setValue(roomData) { (err, ref) in
            if(err == nil){
                self.newRoomTextField.text = ""
            }
        }
    }
}

extension ConversationGroupVC {
    func observeRooms(){
        let roomsRef = Database.database().reference().child("rooms")
        roomsRef.observe(.childAdded) { (data) in
            let myData = data.value as! [String: Any]
            var modelData = Room(array: myData)
            modelData.roomId = data.key
            self.rooms.append(modelData)
            self.chatRoomsTable.reloadData()
        }
    }
}

extension ConversationGroupVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: ConversationGroupCell.self, for: indexPath)
        cell.selectionStyle = .none
        let room = self.rooms[indexPath.row]
        cell.labelName.text = room.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = self.rooms[indexPath.row]
        let vc = RoomVC()
        vc.room = room
        self.push(vc)
    }
}
