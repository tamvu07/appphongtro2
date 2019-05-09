//
//  Screen_Tabar_Custom_Search_02_01_DSOf01_Detail__Chat_ViewController.swift
//  QuanTro
//
//  Created by vuminhtam on 4/30/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit
import Firebase

class Screen_Tabar_Custom_Search_02_01_DSOf01_Detail__Chat_ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var array_user_chat:Array<User> = Array<User>()
    var array_text_chat:Array<String> = Array<String>()
    var array_id_chat:Array<String> = Array<String>()
    var tablename2:DatabaseReference!
    @IBOutlet weak var txt_chat: UITextField!
    @IBOutlet weak var bt_gui: UIButton!
    @IBOutlet weak var view_text: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        print(".........user2 chon la hien tai de  chat la day  :\(vistor).............")
        view_text.layer.cornerRadius = 5
//        moi nha
        array_id_chat.append(currenUser.id)
        array_id_chat.append(vistor.id)
        array_id_chat.sort()
        let key:String = "\(array_id_chat[0])\(array_id_chat[1])"
        tablename2 = ref.child("Chat").child(key)

        // Listen for new comments in the Firebase database
        tablename2.observe(.childAdded, with: { (snapshot) in
            let postDict = snapshot.value as? [String: AnyObject]
            if(postDict != nil)
            {
                if(postDict?["id"]  as! String == currenUser.id )
                {
                    self.array_user_chat.append(currenUser)
                }
                else
                {
                    self.array_user_chat.append(vistor)
                }
                self.array_text_chat.append(postDict?["messager"] as! String)
                self.tableView.reloadData()
            }
        })
    }
    
    
    // button gui
    @IBAction func bt_Gui(_ sender: Any) {
        let messager:Dictionary<String,String> = ["id":currenUser.id,"messager":txt_chat.text!]
        tablename2.childByAutoId().setValue(messager)
        txt_chat.text = ""
        // tao ra 1 bang chat cua nguoi chat va ban dang chat
        if(array_text_chat.count == 0)
        {
            addListChat(user1: currenUser, user2: vistor )
            addListChat(user1: vistor, user2: currenUser)
        }
    }
    
    
    // chua action nha
    @IBAction func bt_search44(_ sender: Any) {
        print(".........bam search ...............\n")
        let scr = self.storyboard?.instantiateViewController(withIdentifier: "Screen_Tabar_Custom_Search_02")
        //        present(scr!, animated: true, completion: nil)
        navigationController?.popToViewController(scr!, animated: true)
        
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txt_chat.layer.borderColor = UIColor.blue.cgColor
        txt_chat.layer.borderWidth = 2.0
        txt_chat.layer.cornerRadius = 5
        bt_gui.backgroundColor = UIColor(red: 0.4, green: 1.0, blue: 0.2, alpha: 0.5)
        bt_gui.layer.cornerRadius = 5
        bt_gui.layer.borderWidth = 1
        bt_gui.layer.borderColor = UIColor.black.cgColor
    }
    
    func addListChat(user1:User,user2:User) {
        let tablename_3 = ref.child("ListChat").child(user1.id).child(user2.id)
        let tt:Dictionary<String,String> = [
            "Email": user2.email,
            "Quyen": String(user2.quyen),
            "LinkAvatar":user2.linkAvatar
        ]
        tablename_3.setValue(tt)
    }
    
    
}

extension Screen_Tabar_Custom_Search_02_01_DSOf01_Detail__Chat_ViewController: UITableViewDelegate, UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_text_chat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(currenUser.id == array_user_chat[indexPath.row].id)
        {
            let Cell = tableView.dequeueReusableCell(withIdentifier: "CELL12", for: indexPath) as! CELL2_Tabar_Custom_Search_02_01_DSOf01_Detail__Chat_TableViewCell
            
            Cell.avatar_2_user.loadavatar(link: currenUser.linkAvatar)
            Cell.lb_2.text = array_text_chat[indexPath.row]
            return Cell
        }else{
            let Cell = tableView.dequeueReusableCell(withIdentifier: "CELL11", for: indexPath) as! CELL1_Tabar_Custom_Search_02_01_DSOf01_Detail__Chat_TableViewCell
            
            Cell.avatar_1_User.loadavatar(link: vistor.linkAvatar)
            Cell.lb_1.text = array_text_chat[indexPath.row]
            return Cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
