//
//  CreateRoomController.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 12/1/18.
//  Copyright © 2018 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Firebase
import FirebaseStorage
import CodableFirebase
import TextFieldEffects

class CreateRoomController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {

    @IBOutlet weak var nameField: AkiraTextField!
    @IBOutlet weak var areaField: AkiraTextField!
    @IBOutlet weak var rentalPriceField: AkiraTextField!
    @IBOutlet weak var maxRoomerField: AkiraTextField!
    @IBOutlet weak var Description: AkiraTextField!
    @IBOutlet weak var address: AkiraTextField!
    @IBOutlet weak var creatAndUpdateButton: UIButton!
    
    var isCreating = false
    let daytro: Quanlydaytro = Store.shared.userMotel.quanlydaytro![Store.shared.indexDaytro]
    var currentRoom:Chitietphong!
    
    @objc var image: UIImage?
    @objc var lastChosenMediaType: String?
    var images = [UIImage]()
    var frameForPage = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if isCreating{
            creatAndUpdateButton.setTitle("Thêm phòng", for: .normal)
        }else{
            creatAndUpdateButton.setTitle("Cập nhật", for: .normal)
            currentRoom = daytro.quanlyphong![Store.shared.indexPhongtro].chitietphong
            setupView()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    
    //MARK: ACTION
    
    @IBAction func tapGestureRecognized(_ sender: Any) {
        nameField.resignFirstResponder()

        maxRoomerField.resignFirstResponder()
        rentalPriceField.resignFirstResponder()
        areaField.resignFirstResponder()
    }
    
    @IBAction func closeKeyboard(_ sender: Any) {
        nameField.resignFirstResponder()
    }
    
    @IBAction func addImage(_ sender: Any) {
//        showActionSheet()
    }
    
    @IBAction func onCreateAndUpdateButtonPressed(_ sender: Any) {
        if nameField.text?.isEmpty == true ||  maxRoomerField.text?.isEmpty == true || rentalPriceField.text?.isEmpty == true || areaField.text?.isEmpty == true || Description.text?.isEmpty == true {
            let alert = UIAlertController(title: "Thiếu thông tin", message: "Bạn cần điền đầy đủ thông tin và thêm đủ hình", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        else {
            if isCreating{
                handleCreateRoom()
                return
            }
            else {
                handleUpdateRoom()
            }
        }
    }
    
    //MARK: -- Picker delegate and datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    

    
    //MARK: HELPER METHOD
    
    func setupUI(){
        creatAndUpdateButton.layer.cornerRadius = 5
        creatAndUpdateButton.layer.shadowOpacity = 1
    }
    
    func handleCreateRoom() {
        let chiTietPhong: Chitietphong = Chitietphong.init(diachi: address.text!, dientich: areaField.text!, gia: Int(rentalPriceField.text!)!, motaphong: Description.text!, songuoidangthue: 0, songuoitoida: Int(maxRoomerField.text!)!, tenphong: nameField.text!)
        
        let uid = Auth.auth().currentUser?.uid
        let idPhong: String = Database.database().reference().childByAutoId().key!
        
        let newRoom: Quanlyphong = Quanlyphong.init(idPhong: idPhong, chitietphong: chiTietPhong)
        Store.shared.userMotel.quanlydaytro![Store.shared.indexDaytro].quanlyphong!.append(newRoom)
        
        let idDAYTRO: String = daytro.iDdaytro!
        
        let lastRoom: Chitietphong = (daytro.quanlyphong?.last!.chitietphong)!
        
        let data: [String:Any] = [
            "Diachi": lastRoom.diachi!,
            "Dientich": lastRoom.dientich!,
            "Gia": lastRoom.gia!,
            "Motaphong": lastRoom.motaphong!,
            "Songuoidangthue": lastRoom.songuoidangthue!,
            "Songuoitoida": lastRoom.songuoitoida!,
            "Tenphong": lastRoom.tenphong!
        ]
        Database.database().reference().child("User/User2/\(uid!)/Quanlydaytro/\(idDAYTRO)/Quanlyphong/\(idPhong)/Chitietphong").setValue(data)
        
        let alert = UIAlertController(title: "Tạo phòng thành công", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func handleUpdateRoom() {
        let chiTietPhong: Chitietphong = Chitietphong.init(diachi: address.text!, dientich: areaField.text!, gia: Int(rentalPriceField.text!)!, motaphong: Description.text!, songuoidangthue: currentRoom.songuoidangthue!, songuoitoida: Int(maxRoomerField.text!)!, tenphong: nameField.text!)
        
        Store.shared.userMotel.quanlydaytro![Store.shared.indexDaytro].quanlyphong![Store.shared.indexPhongtro].chitietphong = chiTietPhong
        
        let uid = Auth.auth().currentUser?.uid
        let idDAYTRO: String = daytro.iDdaytro!
        let idPhong: String = daytro.quanlyphong![Store.shared.indexPhongtro].iDphong!
        
        let data: [String:Any] = [
            "Diachi": chiTietPhong.diachi!,
            "Dientich": chiTietPhong.dientich!,
            "Gia": chiTietPhong.gia!,
            "Motaphong": chiTietPhong.motaphong!,
            "Songuoidangthue": chiTietPhong.songuoidangthue!,
            "Songuoitoida": chiTietPhong.songuoitoida!,
            "Tenphong": chiTietPhong.tenphong!
        ]
    Database.database().reference().child("User/User2/\(uid!)/Quanlydaytro/\(idDAYTRO)/Quanlyphong/\(idPhong)/Chitietphong").setValue(data)

        let alert = UIAlertController(title: "Cập nhật thông tin thành công", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }

    
    
    //MART: setup func
    
    func setupView(){
        if !isCreating && currentRoom != nil {
            nameField.text = currentRoom.tenphong
            areaField.text = currentRoom.dientich
            rentalPriceField.text = String.init(format: "%d", currentRoom.gia ?? 0)
            maxRoomerField.text = String.init(format: "%d", currentRoom.songuoitoida ?? 0)
            Description.text = currentRoom.motaphong
            address.text = currentRoom.diachi
            return
        }
        else {
            print("DANG TAO PHONG TRO MOI")
            return
        }
    }
}
