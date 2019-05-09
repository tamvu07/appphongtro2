//
//  Screen_Tabar_Custom_Search_02_01_DSOf01_Detail_up_ViewController.swift
//  QuanTro
//
//  Created by vuminhtam on 5/9/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit

class Screen_Tabar_Custom_Search_02_01_DSOf01_Detail_up_ViewController: UIViewController {

    @IBOutlet weak var hinh_0: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hinh_0.loadavatar(link: vistor!.linkAvatar)
    }
    

}
