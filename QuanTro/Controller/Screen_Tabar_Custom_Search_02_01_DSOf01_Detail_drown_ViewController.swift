//
//  Screen_Tabar_Custom_Search_02_01_DSOf01_Detail_drown_ViewController.swift
//  QuanTro
//
//  Created by vuminhtam on 5/9/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit

class Screen_Tabar_Custom_Search_02_01_DSOf01_Detail_drown_ViewController: UIViewController {

    @IBOutlet weak var ten_chuphong: UILabel!
    @IBOutlet weak var email_cp: UILabel!
    @IBOutlet weak var sdt_cp: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ten_chuphong.text = ""
        email_cp.text = vistor.email
        sdt_cp.text = ""
    }


}
