//
//  Screen_Main_Customer_ViewController.swift
//  QuanTro
//
//  Created by vuminhtam on 4/18/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit
import Firebase

class Screen_Main_Customer_ViewController: UIViewController , UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource  = self
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! CELL_Main_Customer_TableViewCell
        cell.avatar.layer.cornerRadius = cell.avatar.frame.width/2
        if(indexPath.row == 0)
        {
            cell.lb_text.text = "Đăng xuất"
            cell.avatar.loadavatar(link: currenUser.linkAvatar)
        }
        if(indexPath.row == 1)
        {
            cell.lb_text.text = "Tìm Kiếm"
            cell.avatar.image = UIImage(named: "search")
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0)
        {
           self.isLogOut()
            navigationController?.popToRootViewController(animated: false)
        }
        if(indexPath.row == 1)
        {
            let scr = storyboard?.instantiateViewController(withIdentifier: "MH_Customer_seach")
            navigationController?.pushViewController(scr!, animated: true)
        }
    }
    
    func isLogOut()  {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}
