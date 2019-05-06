//
//  Screen_Tabar_Custom_Search_02_01_ViewController.swift
//  QuanTro
//
//  Created by vuminhtam on 4/30/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit
var Q:String!

class Screen_Tabar_Custom_Search_02_01_ViewController: UIViewController {
    
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let countyNameARR1 = ["a","b","c","d","q","rw","e","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","z","x","c","v","b","n","b","b"]
    
    let countyNameARR = [
        "Quận 1",
        "Quận 12",
        "Quận Thủ Đức",
        "Quận 9",
        "Quận Gò Vấp",
        "Quận Bình Thạnh",
        "Quận Tân Bình",
        "Quận Tân Phú",
        "Quận Phú Nhuận",
        "Quận 2",
        "Quận 3",
        "Quận 10",
        "Quận 11",
        "Quận 4",
        "Quận 5",
        "Quận 6",
        "Quận 8",
        "Quận Bình Tân",
        "Quận 7",
        "Huyện Củ Chi",
        "Huyện Hóc Môn",
        "Huyện Bình Chánh",
        "Huyện Nhà Bè",
        "Huyện Cần Giờ"
    ]
    
    
    var searchCounty = [String]()
    var searching = false
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate   = self
        SearchBar.delegate   = self
        
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let titleView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 25))
        let label:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 25))
        label.text = "\(TP!)"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        titleView.addSubview(label)
        
        self.navigationItem.titleView = titleView
    }
    
    func goto_MH_timkiem_02_01_quan()
    {
        let scr = storyboard?.instantiateViewController(withIdentifier: "MH_timkiem_02_01_DSOf01")
        navigationController?.pushViewController(scr!, animated: true)
    }
    
}

extension Screen_Tabar_Custom_Search_02_01_ViewController: UITableViewDataSource,UITableViewDelegate
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchCounty.count
        }else{
            return countyNameARR.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        if searching {
            cell.textLabel?.text = searchCounty[indexPath.row]
        }else{
            cell.textLabel?.text = countyNameARR[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var text = ""
        if searching {
            text = searchCounty[indexPath.row]
        }else{
            text = countyNameARR[indexPath.row]
        }
        Q = text
        goto_MH_timkiem_02_01_quan()
    }
}

extension Screen_Tabar_Custom_Search_02_01_ViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCounty = countyNameARR.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        SearchBar.text  = ""
        tableView.reloadData()
    }
}
