//
//  ListMotel.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 11/26/18.
//  Copyright © 2018 Le Nguyen Quoc Cuong. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import CodableFirebase

class ListOfMotel {
    private(set)  var listMotel = [Motel]()
    static let shared = ListOfMotel()
    var currentMotelIndex:Int!
    var currentRoomIndex:Int!
    
    public func addMotel(newMotel:Motel){
        listMotel.append(newMotel)
    }
    
    public func updateMotel(newMotel:Motel){
        listMotel[currentMotelIndex] = newMotel
    }
    
    
    public func removeAll(){
        listMotel.removeAll()
        currentMotelIndex = nil
    }
    
    public func addRoom(room:Room){
        if listMotel[currentMotelIndex].listRoom == nil{
            listMotel[currentMotelIndex].listRoom = [Room]()
        }
        listMotel[currentMotelIndex].listRoom?.append(room)
    }
    
    public func updateRoom(newRoom:Room){
        listMotel[currentMotelIndex].listRoom![currentRoomIndex] = newRoom
    }
    
    public func setListMotel(fromList:[Motel]){
        listMotel = fromList
    }
    
    func getListRoomAvailable()->[Room]{
        var listRoomAvailable = [Room]()
        guard let listRoom = listMotel[currentMotelIndex].listRoom else{return listRoomAvailable}
        for room in listRoom{
            if !room.isStaying{
                listRoomAvailable.append(room)
            }
        }
        return listRoomAvailable
    }
    
    func getListRoomUnavailable()->[Room]{
        var listRoomUnavailable = [Room]()
        guard let listRoom = listMotel[currentMotelIndex].listRoom else{return listRoomUnavailable}
        for room in listRoom{
            if room.isStaying{
                listRoomUnavailable.append(room)
            }
        }
        return listRoomUnavailable
    }
    
    func getCurrentMotel()->Motel{
        if currentMotelIndex == nil{
            return Motel()
        }
        return listMotel[currentMotelIndex]
    }
    
    func getCurrentRoom()->Room{
        if currentRoomIndex == nil{
            return Room()
        }
        return listMotel[currentMotelIndex].listRoom![currentRoomIndex]
    }
    
    func addContract(contract:Contract){
        if currentRoomIndex != nil{
            listMotel[currentMotelIndex].listRoom![currentRoomIndex].contract = contract
            listMotel[currentMotelIndex].listRoom![currentRoomIndex].isStaying = true
       
            var listIndex = [Index]()
            listIndex.append(contract.index)
            listMotel[currentMotelIndex].listRoom![currentRoomIndex].listIndex = listIndex
        
        }
    }
    
    func addRoomer(newRoomer:Roomer){
        if listMotel[currentMotelIndex].listRoom![currentRoomIndex].listRoomer == nil{
            listMotel[currentMotelIndex].listRoom![currentRoomIndex].listRoomer = [Roomer]()
        }
        listMotel[currentMotelIndex].listRoom![currentRoomIndex].listRoomer.append(newRoomer)
    }
    
    func saveDataToFirebase(){
        let uid = Auth.auth().currentUser?.uid
        let motel = Store.shared.userMotel!.quanlydaytro
        for item in motel! {
            let idDaytro: String = item.iDdaytro!
            if item.quanlyphong!.count > 0 {
                for item2 in item.quanlyphong! {
                    let idPhong: String = item2.iDphong!
                    let data: [String:Any] = [
                        "Diachi": item2.chitietphong!.diachi!,
                        "Dientich": item2.chitietphong!.dientich!,
                        "Gia": item2.chitietphong!.gia!,
                        "Motaphong": item2.chitietphong!.motaphong!,
                        "Songuoidangthue": item2.chitietphong!.songuoidangthue!,
                        "Songuoitoida": item2.chitietphong!.songuoitoida!,
                        "Tenphong": item2.chitietphong?.tenphong!
                    ]
                    Database.database().reference().child("User/User2/\(uid!)/Quanlydaytro/\(idDaytro)/Quanlyphong/\(idPhong)/Chitietphong").setValue(data)
                }
            }
            else {
                Database.database().reference().child("User/User2/\(uid!)/Quanlydaytro/\(idDaytro)/Quanlyphong/IdDefault/Chitietphong").setValue([
                    "Diachi": "Default",
                    "Dientich": "Default",
                    "Gia": "Default",
                    "Motaphong": "Default",
                    "Songuoidangthue": "Default",
                    "Songuoitoida": "Default"
                    ])
            }
        }
    }
    
    func updateServicePrices(servicePrices:ServicePrices){
        listMotel[currentMotelIndex].servicePrices = servicePrices
    }
    
    func getRoom(withId:String)->Room{
        for room in listMotel[currentMotelIndex].listRoom!{
            if withId == room.id{
                return room
            }
        }
        return Room()
    }
    
    func getDayCollectingRent()->Int{
        return listMotel[currentMotelIndex].dayCollectingRent
    }
    
    func updateCollectedRent(dict:[String:[String:Bool]]){
        listMotel[currentMotelIndex].collectedRent = dict
    }
    
    func getCollectedRent()->[String:[String:Bool]]{
        if listMotel[currentMotelIndex].collectedRent == nil{
            return [String:[String:Bool]]()
        }
        return listMotel[currentMotelIndex].collectedRent
    }
    
    func getCollectedFee()->[String:[FeeBill]]{
        if listMotel[currentMotelIndex].collectedFee == nil{
            return [String:[FeeBill]]()
        }
        return listMotel[currentMotelIndex].collectedFee
    }
    
    func updateListIndex(withIdRoom id:String, newIndex:Index){
        for i in 0..<listMotel[currentMotelIndex].listRoom!.count{
            if listMotel[currentMotelIndex].listRoom![i].id == id{
                listMotel[currentMotelIndex].listRoom![i].listIndex.append(newIndex)
            }
        }
    }
    
    func getServicePrice()->ServicePrices{
        return listMotel[currentMotelIndex].servicePrices
    }
    
    func addFeeBill(key:String, feeBill:FeeBill){
        if listMotel[currentMotelIndex].collectedFee == nil{
            listMotel[currentMotelIndex].collectedFee = [String:[FeeBill]]()
        }
        if listMotel[currentMotelIndex].collectedFee[key] == nil{
            listMotel[currentMotelIndex].collectedFee.updateValue([FeeBill](), forKey: key)
        }
        listMotel[currentMotelIndex].collectedFee[key]?.append(feeBill)
    }
    
    func updateCollectedFee(withKey key:String, listFeeBill:[FeeBill]){
        listMotel[currentMotelIndex].collectedFee.updateValue(listFeeBill, forKey: key)
    }
    
    func getRoomName(withRoomID id:String)->String{
        guard let listRoom = listMotel[currentMotelIndex].listRoom else {
            return ""
        }
        for room in listRoom{
            if room.id == id{
                return room.name
            }
        }
        return ""
    }
    
    func updateRoomer(withIndex index:Int, roomer:Roomer){
        listMotel[currentMotelIndex].listRoom![currentRoomIndex].listRoomer![index] = roomer
    }
    
    func deleteRoomer(withIndex index:Int){
        listMotel[currentMotelIndex].listRoom![currentRoomIndex].listRoomer!.remove(at: index)
    }
    
    func cancelContractForCurrentRoom(){
        listMotel[currentMotelIndex].listRoom![currentRoomIndex].isStaying = false
        listMotel[currentMotelIndex].listRoom![currentRoomIndex].listRoomer.removeAll()
        listMotel[currentMotelIndex].listRoom![currentRoomIndex].contract = nil
        listMotel[currentMotelIndex].listRoom![currentRoomIndex].listIndex.removeAll()
        
    }
    
    func getListNameRoomer()->[String]{
        var result = [String]()
        guard let listRoom = listMotel[currentMotelIndex].listRoom else{return result}
        
        for room in listRoom{
            guard let listRoomer = room.listRoomer else{continue}
            for roomer in listRoomer{
                result.append(roomer.name)
            }
        }
        return result
    }
    
    func addVehicle(newVehicle:Vehicle){
        if listMotel[currentMotelIndex].listVehicle == nil{
            listMotel[currentMotelIndex].listVehicle = [Vehicle]()
        }
        listMotel[currentMotelIndex].listVehicle.append(newVehicle)
    }
    
    func getListVehicle()->[Vehicle]{
        if listMotel[currentMotelIndex].listVehicle == nil{
            return [Vehicle]()
        }
        
        return listMotel[currentMotelIndex].listVehicle
    }
    
    func getListRoom()->[Room]{
        return listMotel[currentMotelIndex].listRoom ?? [Room]()
    }
    
    func deleteRoom(withIndex index:Int){
        listMotel[currentMotelIndex].listRoom!.remove(at: index)
    }
    
    func deleteMotel(withIndex index:Int){
        Store.shared.userMotel.quanlydaytro?.remove(at: index)
    }
    
    func deleteVehicle(withIndex index:Int){
        listMotel[currentMotelIndex].listVehicle.remove(at: index)
    }
    
}
