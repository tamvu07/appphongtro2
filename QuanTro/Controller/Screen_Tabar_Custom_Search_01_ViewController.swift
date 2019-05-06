//
//  Screen_Tabar_Custom_Search_01_ViewController.swift
//  QuanTro
//
//  Created by vuminhtam on 4/22/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit

class Screen_Tabar_Custom_Search_01_ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
    }

}

extension Screen_Tabar_Custom_Search_01_ViewController : UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0)
        {
            return 1
        }
        return chuphongs.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellID = ""
        if (indexPath.section == 0)
        {
            cellID = CELL1_Table_Tabar_Custom_Search_01_TableViewCell.CELL1
        }else {
            cellID = CELL2_Table_Tabar_Custom_Search_01_TableViewCell.CELL2
        }
        
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        if (indexPath.section == 0)
        {
            let a = cell as! CELL1_Table_Tabar_Custom_Search_01_TableViewCell
            
            let dataForCell = [
                                    images(imageNamed: "background1"),
                                     images(imageNamed: "background2"),
                                      images(imageNamed: "background3")
                             ]
            
            a.updateUI(width: dataForCell)
        }else{
            let b = cell as! CELL2_Table_Tabar_Custom_Search_01_TableViewCell
            b.lb_diachi.text = chuphongs[indexPath.row].diachi
            b.lb_tien.text = chuphongs[indexPath.row].gia
            let avatar = chuphongs[indexPath.row].linkAvatar
            let url:URL = URL(string: avatar!)!
            do
            {
                let dulieu:Data = try Data(contentsOf: url)
                b.image_1.image = UIImage(data: dulieu)
            }
            catch
            {
                print("khong lay dc du lieu !")
            }
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if(section == 0)
//        {
//            return nil
//        }
//        return "hhhhhhhh"
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if(section == 0)
        {
            return nil
        }
        
        let view  = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30)
        )
        view.backgroundColor      = UIColor.red
        let titleLb               = UILabel(frame: view.bounds)
        titleLb.text              = "xin chao !"
        titleLb.textAlignment     = .center
        titleLb.font              = UIFont(name: "HelveticaNeue-Bold", size: 30.0)
        view.addSubview(titleLb)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section==0) ? 0:30
    }
  
    
    
}
