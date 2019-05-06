//
//  Screen_Tabar_Custom_Search_02_01_DSOf01_ViewController.swift
//  QuanTro
//
//  Created by vuminhtam on 4/30/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit

var vistor:User!

class Screen_Tabar_Custom_Search_02_01_DSOf01_ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var listUser2:Array<User> = Array<User>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate   = self
        self.load_table()
        
        let tablename = ref.child("User").child("User2")
        // Listen for new comments in the Firebase database
        tablename.observe(.childAdded, with: { (snapshot) in
            // kiem tra xem postDict co du lieu hay ko
            let postDict = snapshot.value as? [String : AnyObject]
            
            /*
             let postDict = snapshot.value ?? nil
             let data: Class?
             do {
                data = try FirebaseDecoder().decode(Class.self, from: postDict)
             }
             catch let error {
             print(error)
             }
             data.quanlythongtincanhan.linkAvatar
             */
            
            if(postDict != nil)
            {
                let id_User2 = snapshot.key
                let User2_current_QLTT = (postDict?["Quanlythongtincanhan"]) as! NSMutableDictionary
                let email:String = (User2_current_QLTT["Email"])! as? String ?? "taolao@gmail.com"
                let quyen:String = (User2_current_QLTT["Quyen"])! as? String ?? "taolao"
                let linkAvatar:String = (User2_current_QLTT["LinkAvatar"])! as? String ?? "taolao"
                
                let user2:User = User(id: id_User2, email: email, linkAvatar: linkAvatar, quyen: Int(quyen)!)
                self.listUser2.append(user2)
                self.tableView.reloadData()
            }
        })
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let titleView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 25))
        let label:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 25))
        label.text = "\(Q!)"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        titleView.addSubview(label)
        
        self.navigationItem.titleView = titleView
    }
    
    func goto_MH_Search_02_01_DSOf01_detail(){
        let scr = storyboard?.instantiateViewController(withIdentifier: "MH_timkiem_02_01_DSOf01_datail")
        navigationController?.pushViewController(scr!, animated: true)
    }
}

extension Screen_Tabar_Custom_Search_02_01_DSOf01_ViewController: UITableViewDataSource,UITableViewDelegate
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listUser2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        let image = cell.viewWithTag(100) as! UIImageView
        let lb_diachi = cell.viewWithTag(101) as! UILabel
        let lb_gia    = cell.viewWithTag(102)  as! UILabel
        
        image.loadavatar(link: listUser2[indexPath.row].linkAvatar)
        lb_diachi.text = listUser2[indexPath.row].email
        lb_gia.text = String(listUser2[indexPath.row].quyen)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        vistor = listUser2[indexPath.row]
        self.goto_MH_Search_02_01_DSOf01_detail()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func load_table() {
        
//        var tablename = ref.child("User").child("User2")
//        tablename.observe(.childAdded, with: { (snapshot) in
//            // kiem tra xem postDict co du lieu hay ko
//            let postDict = snapshot.value as? [String : AnyObject]
//            if(postDict != nil)
//            {
////             self.listFriend.append(user)
//            }
//        })
    }
    
    
}
