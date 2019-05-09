//
//  CELL_Tabar_Custom_Search_02_01_DSOf01_TableViewCell.swift
//  QuanTro
//
//  Created by vuminhtam on 4/30/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//
import UIKit

class CELL_Tabar_Custom_Search_02_01_DSOf01_TableViewCell: UITableViewCell {
    
    @IBOutlet weak var image_phong: UIImageView!
    @IBOutlet weak var lb_diachi_phong: UILabel!
    @IBOutlet weak var lb_giaphong: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        image_phong.layer.cornerRadius = image_phong.frame.width/2
//        image_phong.layer.borderWidth = 2.0
//        image_phong.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
