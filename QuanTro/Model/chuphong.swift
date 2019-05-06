//
//  chuphong.swift
//  QuanTro
//
//  Created by vuminhtam on 4/19/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import Foundation
import UIKit

struct ChuPhong {
    let id:String!
    let ten:String!
    let linkAvatar:String!
    var avatar:UIImage!
    let diachi:String!
    let gia:String!
    let motaphong:String!
    let email:String!
    let sdt:String!
    let dientich:String!
    
    init()
    {
        id = ""
        ten = ""
        linkAvatar = ""
        avatar = UIImage(named: "person")
        diachi = ""
        gia = ""
        motaphong = ""
        email = ""
        sdt = ""
        dientich = ""
    }
    
    init(id:String,ten:String, linkAvatar:String, diachi:String, gia:String, motaphong:String,email:String,sdt:String,dientich:String) {
        self.id = id
        self.ten = ten
        self.linkAvatar = linkAvatar
        self.avatar = UIImage(named: "person")
        self.diachi = diachi
        self.gia = gia
        self.motaphong = motaphong
        self.email = email
        self.sdt = sdt
        self.dientich = dientich
    }
    
}
