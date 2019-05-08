//
//  Helper.swift
//  QuanTro
//
//  Created by Flint Pham on 5/2/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import Foundation
import Firebase

class Helper {
    static var shared: Helper = Helper()
    
    func fetchData(tableName: DatabaseReference, currentUserId: String, completion: @escaping (_ result: NewUser, _ error: String) -> Void) {
        tableName.observe(.childAdded) { (snapshot) in
            if let postDict = snapshot.value as? [String:Any], currentUserId == snapshot.key {
                let thongtin: [String:Any] = postDict["Quanlythongtincanhan"] as! [String:Any]
                let canhan = Quanlythongtincanhan.init(email: thongtin["Email"] as! String, linkAvatar: thongtin["LinkAvatar"] as! String, quyen: thongtin["Quyen"] as! String, sdt: thongtin["Sdt"] as! String, ten: thongtin["Ten"] as! String)
                
                let thongtincanhan: Quanlythongtincanhan = canhan
                var daytro: [Quanlydaytro] = []
                var phongtro: [Quanlyphong] = []
                var chitiet: Chitietphong = Chitietphong.init(diachi: "", dientich: "", gia: 0, motaphong: "", songuoidangthue: 0, songuoitoida: 0, tenphong: "")
                var thanhvien: [ThanhVien] = []
                
                // KIEM TRA NEU CO KEY QUANLYDAYTRO
                if let _ = postDict["Quanlydaytro"] {
                    // DAY TRO
                    for item in postDict["Quanlydaytro"] as! NSMutableDictionary {
                        
                        if let data: [String:Any] = item.value as? [String:Any] {
                            
                            // PHONG
                            for item2 in data["Quanlyphong"] as! NSMutableDictionary {
                                if item2.key as! String != "IdDefault" {
                                    let data2 = item2.value as! [String:Any]

                                    let chitietphong = data2["Chitietphong"] as! [String:Any]
                                    
                                    chitiet.gia = chitietphong["Gia"] as? Int
                                    chitiet.diachi = chitietphong["Diachi"] as? String
                                    chitiet.dientich = chitietphong["Dientich"] as? String
                                    chitiet.motaphong = chitietphong["Motaphong"] as? String
                                    chitiet.songuoitoida = chitietphong["Songuoitoida"] as? Int
                                    chitiet.songuoidangthue = chitietphong["Songuoidangthue"] as? Int
                                    chitiet.tenphong = chitietphong["Tenphong"] as? String
                                    
                                    if let thanhvienRoomer: NSMutableDictionary = data2["Quanlythanhvien"] as? NSMutableDictionary {
                                        for item3 in thanhvienRoomer {
                                            let thongtinRoomer = item3.value as! [String:Any]
                                            
                                            let tenRoomer: String = (thongtinRoomer["Ten"] as? String)!
                                            let ngaysinhRoomer: String = (thongtinRoomer["Ngaysinh"] as? String)!
                                            let cmndRoomer: Double = (thongtinRoomer["CMND"] as? Double)!
                                            let sdtRoomer: Double = (thongtinRoomer["SDT"] as? Double)!
                                            let avarRoomer: String = thongtinRoomer["Avatar"] as? String ?? ""
                                            
                                            let roomer: ThanhVien = ThanhVien.init(idThanhVien: item3.key as! String, ten: tenRoomer, ngaysinh: ngaysinhRoomer, cmnd: cmndRoomer, sdt: sdtRoomer, avatar: avarRoomer)
                                            thanhvien.append(roomer)
                                        }
                                    }
                                    
                                    chitiet.songuoidangthue = thanhvien.count
                                    
                                    phongtro.append(Quanlyphong.init(idPhong: item2.key as! String, chitietphong: chitiet, thanhvien:thanhvien))
                                    thanhvien = []
                                }
                                else {

                                }
                            }
                            
                            daytro.append(Quanlydaytro.init(idDaytro: item.key as! String, quanlyphong: phongtro))
                            phongtro = []
                        }
                        else {
                            daytro.append(Quanlydaytro.init(idDaytro: item.key as! String, quanlyphong: []))
                            phongtro = []
                        }
                    }
                }
                else {
                    daytro = []
                }
                let newUser: NewUser = NewUser.init(userID: snapshot.key, Quanlydaytro: daytro, Quanlythongtincanhan: thongtincanhan)
                daytro = []
                completion(newUser,"")
            }
            else {
                print("ERROR SNAPSHOT.VALUE")
                completion(NewUser.init(userID: "", Quanlydaytro: [], Quanlythongtincanhan: Quanlythongtincanhan.init(email: "", linkAvatar: "", quyen: "", sdt: "", ten: "")),"Error userModel = nil")
            }
        }
    }
}
