//
//  Screen_Tabar_Custom_Search_02_01_DSOf01_Detail__Chat_ViewController.swift
//  QuanTro
//
//  Created by vuminhtam on 4/30/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit
import Firebase

class Screen_Tabar_Custom_Search_02_01_DSOf01_Detail__Chat_ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var array_user_chat:Array<User> = Array<User>()
    var array_text_chat:Array<String> = Array<String>()
    var array_id_chat:Array<String> = Array<String>()
     var tablename2:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        print(".........user2 chon la hien tai de  chat la day  :\(vistor).............")
        
        self.array_user_chat.append(currenUser)
        self.array_user_chat.append(vistor)

//        let tablename = ref.child("User").child("User1")
//        // Listen for new comments in the Firebase database
//        tablename.observe(.childAdded, with: { (snapshot) in
//            // kiem tra xem postDict co du lieu hay ko
//            let postDict = snapshot.value as? [String : AnyObject]
//            if(postDict != nil)
//            {
//
//                if(snapshot.key == (currenUser.id)!)
//                {
//                    print("....ok 1.......")
////                    self.array_user_chat.append(currenUser)
//
//                }else{
//                    self.array_user_chat.append(vistor)
//                    print("....ok 2.......")
//                }
//                self.tableView.reloadData()
//            }
//
//        })
        
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
    
    // bam nut goi se goi tin nhan
    @IBAction func bt_Goi_chua_co_lam_nha(_ sender: Any) {
        let messager:Dictionary<String,String> = ["id":currenUser.id,"messager":"......"]
        tablename2.childByAutoId().setValue(messager)
//        txt_messager.text = ""
        // tao ra 1 bang chat cua nguoi chat va ban dang chat
        if(array_text_chat.count == 0)
        {
//            addListChat(user1: currenUser, user2: vistor )
//            addListChat(user1: vistor, user2: currenUser)
        }
    }
    
    
}

extension Screen_Tabar_Custom_Search_02_01_DSOf01_Detail__Chat_ViewController: UITableViewDelegate, UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_user_chat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if(currenUser.id == array_user_chat[indexPath.row].id)
        {
            let Cell = tableView.dequeueReusableCell(withIdentifier: "CELL12", for: indexPath) as! CELL2_Tabar_Custom_Search_02_01_DSOf01_Detail__Chat_TableViewCell
            
            Cell.avatar_2_user.loadavatar(link: currenUser.linkAvatar)
            Cell.lb_2.text = currenUser.email
             return Cell
        }else{
            let Cell = tableView.dequeueReusableCell(withIdentifier: "CELL11", for: indexPath) as! CELL1_Tabar_Custom_Search_02_01_DSOf01_Detail__Chat_TableViewCell
            
            Cell.avatar_1_User.loadavatar(link: vistor.linkAvatar)
            Cell.lb_1.text = vistor.email
            return Cell
        }

        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
