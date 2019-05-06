//
//  CELL2_Table_Tabar_Custom_Search_01_TableViewCell.swift
//  QuanTro
//
//  Created by vuminhtam on 4/22/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit

class CELL2_Table_Tabar_Custom_Search_01_TableViewCell: UITableViewCell {
    static let CELL2 = "CELL2"
    
    @IBOutlet weak var image_1: UIImageView!
    @IBOutlet weak var lb_diachi: UILabel!
    @IBOutlet weak var lb_tien: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
