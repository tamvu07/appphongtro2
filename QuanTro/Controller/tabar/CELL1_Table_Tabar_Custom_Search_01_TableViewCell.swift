//
//  CELL_Table_Tabar_Custom_Search_01_TableViewCell.swift
//  QuanTro
//
//  Created by vuminhtam on 4/22/19.
//  Copyright © 2019 Le Nguyen Quoc Cuong. All rights reserved.
//

import UIKit

struct images {
    var imageNamed:String
}

class CELL1_Table_Tabar_Custom_Search_01_TableViewCell: UITableViewCell {

    static let CELL1 = "CELL1"
    
    @IBOutlet weak var CollectionView: UICollectionView!
    
    var data_Image:[images] = []
    
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        CollectionView.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(width data:[images])
    {
        self.data_Image = data
        CollectionView.reloadData()
    }

}

extension CELL1_Table_Tabar_Custom_Search_01_TableViewCell: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data_Image.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CollectionView.dequeueReusableCell(withReuseIdentifier: "CELL_CELL_01", for: indexPath) as! CELL_CELL1_Table_Custom_Search_01_CollectionViewCell
        let a = data_Image[indexPath.item]
        cell.image_lb.image = UIImage(named: a.imageNamed)
        return cell
    }
}
