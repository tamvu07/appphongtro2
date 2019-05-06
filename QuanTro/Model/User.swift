//
//  User.swift
//  QuanTro
//
//  Created by vuminhtam on 4/17/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import Foundation
import UIKit

struct User {
    let id:String!
    let email:String!
    let linkAvatar:String!
    var Avatar:UIImage!
    var quyen:Int!
    
//    init()
//    {
//        id = ""
//        email = ""
//        linkAvatar = ""
//        Avatar = UIImage(named: "person")
//        quyen = 0
//    }
    
    init(id:String = "",email:String = "" ,linkAvatar:String = "" ,quyen:Int = 0) {
        self.id = id
        self.email = email
        self.linkAvatar = linkAvatar
        self.Avatar = UIImage(named: "person")
        self.quyen = quyen
    }
    
}

