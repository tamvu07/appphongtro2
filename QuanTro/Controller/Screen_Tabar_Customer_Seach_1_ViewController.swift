////
////  Screen_Tabar_Customer_Seach_1_ViewController.swift
////  QuanTro
////
////  Created by vuminhtam on 4/19/19.
////  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
////
//
//import UIKit
//
//class Screen_Tabar_Customer_Seach_1_ViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
//
//    @IBOutlet weak var collectionView: UICollectionView!
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        collectionView.delegate = self
//        collectionView.dataSource = self
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return chuphongs.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! CELL_Customer_Seach_1_CollectionViewCell
//        cell.backgroundColor = UIColor.yellow
//        let avatar = chuphongs[indexPath.row].linkAvatar
//        let url:URL = URL(string: avatar!)!
//        do
//        {
//            let dulieu:Data = try Data(contentsOf: url)
//            cell.avatar.image = UIImage(data: dulieu)
//        }
//        catch
//        {
//            print("khong lay dc du lieu !")
//        }
//
//        cell.lb_diachi.text = chuphongs[indexPath.row].diachi
//        cell.lb_dientich.text = chuphongs[indexPath.row].dientich
//        cell.lb_gia.text = chuphongs[indexPath.row].gia
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 300, height: 150)
//    }
//
////    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        return
////    }
//}
