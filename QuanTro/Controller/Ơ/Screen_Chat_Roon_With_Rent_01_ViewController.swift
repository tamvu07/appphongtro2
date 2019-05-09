//
//  Screen_Chat_Roon_With_Rent_01_ViewController.swift
//  QuanTro
//
//  Created by vuminhtam on 5/9/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit

class Screen_Chat_Roon_With_Rent_01_ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var listUser1:Array<User> = Array<User>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate   = self
        
        let tablename = ref.child("User").child("User1")
        // Listen for new comments in the Firebase database
        tablename.observe(.childAdded, with: { (snapshot) in
            // kiem tra xem postDict co du lieu hay ko
            let postDict = snapshot.value as? [String : AnyObject]
            
            if(postDict != nil)
            {
                let id_User1 = snapshot.key
                let User1_current_QLTT = (postDict?["Quanlythongtincanhan"]) as! NSMutableDictionary
                let email:String = (User1_current_QLTT["Email"])! as? String ?? "chuaco@gmail.com"
                let quyen:String = (User1_current_QLTT["Quyen"])! as? String ?? "0"
                let linkAvatar:String = (User1_current_QLTT["LinkAvatar"])! as? String ?? "chuaco"
                
                let user1:User = User(id: id_User1, email: email, linkAvatar: linkAvatar, quyen: Int(quyen)!)
                self.listUser1.append(user1)
                self.tableView.reloadData()
            }
        })
        
    }
    
    func goto_Screen_Chat_Room_With_Rent_01_01(){
        let scr = storyboard?.instantiateViewController(withIdentifier: "Screen_Chat_Room_With_Rent_01_01")
        navigationController?.pushViewController(scr!, animated: true)
    }
    
}

extension Screen_Chat_Roon_With_Rent_01_ViewController: UITableViewDataSource,UITableViewDelegate
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listUser1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        let image = cell.viewWithTag(100) as! UIImageView
        let lb_email    = cell.viewWithTag(102)  as! UILabel
        var view = cell.viewWithTag(99) as! UIView
        var contentView = cell.viewWithTag(98)
        view.backgroundColor = UIColor.white
        contentView!.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        view.layer.cornerRadius = 3.0
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.8
        
        image.loadavatar(link: listUser1[indexPath.row].linkAvatar)
        lb_email.text = listUser1[indexPath.row].email
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        vistor = listUser1[indexPath.row]
        self.goto_Screen_Chat_Room_With_Rent_01_01()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
