
import UIKit
import FirebaseStorage
import Firebase

class ListRoomerController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var listRoomer: [ThanhVien]!
    var chiTietPhong: Chitietphong!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(RoomerCell.self, forCellReuseIdentifier: "RoomerCell")
        let nib = UINib(nibName: "RoomerCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "RoomerCell")
        tableView.rowHeight = 110
        
        listRoomer = Store.shared.userMotel.quanlydaytro![Store.shared.indexDaytro].quanlyphong![Store.shared.indexPhongtro].thanhvien!
        chiTietPhong = Store.shared.userMotel.quanlydaytro![Store.shared.indexDaytro].quanlyphong![Store.shared.indexPhongtro].chitietphong
}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    // MARK:- DELEGATE and DATASOURCE OF TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listRoomer.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == listRoomer.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlusCell", for: indexPath)
            
            let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.tableView.frame.size.width - 20, height: self.tableView.rowHeight - 16))
            
            whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.8])
            whiteRoundedView.layer.masksToBounds = false
            whiteRoundedView.layer.cornerRadius = 4.0
            whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: -1)
            
            whiteRoundedView.layer.borderColor = UIColor.gray.cgColor
            
            whiteRoundedView.layer.borderWidth = 2
            whiteRoundedView.layer.shadowOpacity = 0.2
            cell.contentView.addSubview(whiteRoundedView)
            cell.contentView.sendSubviewToBack(whiteRoundedView)
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomerCell", for: indexPath) as! RoomerCell
        
        let cellSize = tableView.getSizeCell()
        cell.contentView.addSubview(cellSize)
        cell.contentView.sendSubviewToBack(cellSize)
        
        if let _ = listRoomer[indexPath.row].avatar{
            let roomer: ThanhVien = listRoomer![indexPath.row]
            let cmndRoomer: String = String.init(format: "%.0f", roomer.cmnd!)
            let idThanhvien: String = roomer.idThanhVien!
            let storageRef = Storage.storage().reference().child("imagesOfRoomer/\(idThanhvien)/\(cmndRoomer).jpg")
            storageRef.getData(maxSize: 4*1024*1024) { (data, error) in
                if error != nil{
                    print(error!)
                    cell.imageV.image = UIImage.init(named: "person")
                }else{
                    DispatchQueue.main.async{
                        cell.imageV.image = UIImage.init(data: data!)
                    }
                }

            }
        }
        else {
            cell.imageV.image = UIImage.init(named: "person")
        }
        
        cell.name.text = listRoomer[indexPath.row].ten
        cell.numPhone.text = String.init(format: "%.0f", listRoomer[indexPath.row].sdt!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == listRoomer.count &&  chiTietPhong.songuoitoida! <= listRoomer.count{
            let alert = UIAlertController(title: "Không thể tạo người trọ", message: "Số người trọ của phòng này đã tới mức giới hạn", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        self.performSegue(withIdentifier: "FromListRoomerToCreate", sender: tableView.cellForRow(at: indexPath))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPath(for: (sender as! UITableViewCell))
        let newVC = segue.destination as! CreateRoomerController
        newVC.isCreating = indexPath?.row == listRoomer.count ? true:false
        Store.shared.indexRoomer = indexPath?.row
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row == listRoomer.count ? false:true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            let actionSheet = UIAlertController(title: "Bạn muốn xoá người trọ này?", message: "Nếu xoá sẽ không thể khôi phục lại người trọ này", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Tôi muốn xoá", style: .destructive, handler: { (action) in
//                ListOfMotel.shared.deleteRoomer(withIndex: indexPath.row)
//                self.listRoomer.remove(at: indexPath.row)
//                ListOfMotel.shared.saveDataToFirebase()
                
                let idThanhvien: String = (self.listRoomer?[indexPath.row].idThanhVien)!
                
                let uid: String = Auth.auth().currentUser!.uid
                let idDaytro: String = Store.shared.userMotel.quanlydaytro![Store.shared.indexDaytro].iDdaytro!
                let idPhong: String = Store.shared.userMotel.quanlydaytro![Store.shared.indexDaytro].quanlyphong![Store.shared.indexPhongtro].iDphong!
                
                let ref = Database.database().reference().child("User/User2/\(uid)/Quanlydaytro/\(idDaytro)/Quanlyphong/\(idPhong)/Quanlythanhvien/\(idThanhvien)")
                ref.removeValue()
                
                self.listRoomer.remove(at: indexPath.row)
                Store.shared.userMotel.quanlydaytro![Store.shared.indexDaytro].quanlyphong![Store.shared.indexPhongtro].thanhvien?.remove(at: indexPath.row)
                
                let songuoidangthue: Int = (Store.shared.userMotel.quanlydaytro![Store.shared.indexDaytro].quanlyphong![Store.shared.indexPhongtro].chitietphong?.songuoidangthue!)! - 1
                let updateDataPhong: [String:Any] = ["Songuoidangthue": songuoidangthue]
                Database.database().reference().child("User/User2/\(uid)/Quanlydaytro/\(idDaytro)/Quanlyphong/\(idPhong)/Chitietphong").updateChildValues(updateDataPhong)
                
                Store.shared.userMotel.quanlydaytro![Store.shared.indexDaytro].quanlyphong![Store.shared.indexPhongtro].chitietphong?.songuoidangthue = songuoidangthue
                
                let alert = UIAlertController(title: "Xoá người trọ thành công", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.tableView.reloadData()
            }))
            actionSheet.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
            present(actionSheet, animated: true, completion: nil)
        }
    }
}
