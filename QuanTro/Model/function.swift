//
//  function.swift
//  QuanTro
//
//  Created by vuminhtam on 4/30/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import TextFieldEffects
import DLRadioButton
import FirebaseAuth
import FirebaseStorage


class chucnang
{
    func tabar_lable() {
        let titleView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 25))
        let label:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 25))
        label.text = "\(TP!)"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        titleView.addSubview(label)
        
        //        self.navigationItem.titleView = titleView
    }
    
    func kiemraUser_addUser() -> Int{
        // tao tai khoan thanh cong thi se luu thong tin nguoi dung vao database
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let email = user.email
            let photoURL = user.photoURL
            let quyen = quyenUser
            currenUser = User(id: uid, email: email!, linkAvatar: String("\(photoURL!)") , quyen: quyen!)
            var u = ""
            if(currenUser.quyen == 1)
            {
                u = "User1"
            }else
            {
                u = "User2"
            }
            let tableUser = ref.child("User").child("\(u)").child(currenUser.id).child("Quanlythongtincanhan")
            
            let tt:Dictionary<String,String> = [
                "Email": currenUser.email,
                "Quyen": String(currenUser!.quyen),
                "LinkAvatar":currenUser.linkAvatar,
                "Ten":"...",
                "Sdt":"..."
            ]
            
            tableUser.setValue(tt)
            
            let url:URL = URL(string: currenUser.linkAvatar)!
            do{
                let data:Data = try Data(contentsOf: url)
                currenUser.Avatar = UIImage(data: data)
            }
            catch{
                print("loi load hinh")
            }
        }
        
        return  currenUser.quyen
    }
    
    func kiemraUser_GetUser() -> Int{
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let email = user.email
            let photoURL = user.photoURL
            
            currenUser = User(id: uid, email: email!, linkAvatar: String("\(photoURL!)"), quyen: 0)
            
        }
        else
        {
            print("khong co user !.............")
        }
        
        var u = "User1"
        var kt = 0
        var ql = "Quanlythongtincanhan"
        
        
        
        repeat{
            // ref.child de truy van table trong database , lay ra ID current USER hien tai
            let tablename = ref.child("User").child("\(u)")
            // Listen for new comments in the Firebase database
            tablename.observe(.childAdded, with: { (snapshot) in
                // kiem tra xem postDict co du lieu hay ko
                let postDict = snapshot.value as? [String : AnyObject]
                if(postDict != nil)
                {
                    if(currenUser.id == snapshot.key)
                    {
                        //                    for (name, path) in postDict! {
                        //                        print("The key '\(name)' ...doi tuong la.... '\(path)'.")
                        //                        let p = path as! Dictionary<String,String>
                        //                        for (a, b) in p {
                        //                            print("chi tiet doi tuong la '\(a)' ....va..... '\(b)'.")
                        //                            if(a == "Quyen")
                        //                            {
                        //                                q = Int(b)!
                        //                                currenUser.quyen = q
                        //                            }
                        //                        }
                        //
                        //                    }
                        let User_current = (postDict!["Quanlythongtincanhan"]) as! NSMutableDictionary
                        
                        
                        let email:String = (User_current["Email"])! as! String
                        let quyen:String = (User_current["Quyen"])! as! String
                        let linkAvatar:String = (User_current["LinkAvatar"])! as! String
                        
                        let user:User = User(id: snapshot.key, email: email, linkAvatar: linkAvatar, quyen: Int(quyen)!)
                        currenUser = user
                        print("////////quyen la :\(currenUser.quyen)////////////")
                        kt =  1
                    }
                }
            })
            if(kt == 0)
            {
                u = "User2"
            }
        }while kt == 1
        return 0
    }
    
}
