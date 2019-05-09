//
//  Screen_Tabar_Custom_Search_02_ViewController.swift
//  QuanTro
//
//  Created by vuminhtam on 4/30/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit
var TP:String!

class Screen_Tabar_Custom_Search_02_ViewController: UIViewController {
    
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let countryNameARR2 = ["a","b","c","d","q","rw","e","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","z","x","c","v","b","n","b","b"]
    
//        let countryNameARR = [
//            "Thành Phố Hồ Chí Minh"
//        ]
    
    let countryNameARR = [
        "An Giang",
        "Bà Rịa - Vũng Tàu",
        "Bắc Giang",
        "Bắc Kạn",
        "Bạc Liêu",
        "Bắc Ninh",
        "Bến Tre",
        "Bình Định",
        "Bình Dương",
        "Bình Phước",
        "Bình Thuận",
        "Cà Mau",
        "Cao Bằng",
        "Đắk Lắk",
        "Đắk Nông",
        "Điện Biên",
        "Đồng Nai",
        "Đồng Tháp",
        "Gia Lai",
        "Hà Giang",
        "Cần Thơ",
        "Đà Nẵng",
        "Hải Phòng",
        "Hà Nội",
        "Thành Phố Hồ Chí Minh",
        "Quảng Nam",
        "Quảng Ngãi",
        "Quảng Ninh",
        "Quảng Trị",
        "Sóc Trăng",
        "Sơn La",
        "Tây Ninh",
        "Thái Bình",
        "Thái Nguyên",
        "Thanh Hóa",
        "Thừa Thiên Huế",
        "Tiền Giang",
        "Trà Vinh",
        "Tuyên Quang",
        "Vĩnh Long"
    ]
    
    var searchCountry = [String]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        super.viewDidLoad()
        
        
    }
    
    func goto_MH_timkiem_02_01()
    {
        let scr = storyboard?.instantiateViewController(withIdentifier: "MH_timkiem_02_01")
        navigationController?.pushViewController(scr!, animated: true)
    }
    
}

extension Screen_Tabar_Custom_Search_02_ViewController: UITableViewDataSource,UITableViewDelegate
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchCountry.count
        }else{
            return countryNameARR.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        if searching {
            cell.textLabel?.text = searchCountry[indexPath.row]
        }else{
            cell.textLabel?.text = countryNameARR[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var text = ""
        if searching {
            text = searchCountry[indexPath.row]
        }else{
            text = countryNameARR[indexPath.row]
        }
        if(text == "Thành Phố Hồ Chí Minh")
        {
            TP = text
            goto_MH_timkiem_02_01()
        }

    }
}

extension Screen_Tabar_Custom_Search_02_ViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCountry = countryNameARR.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text  = ""
        tableView.reloadData()
    }
}
