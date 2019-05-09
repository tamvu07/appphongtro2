
import UIKit
import FirebaseStorage
//import GoogleSignIn
import Firebase

class ListMotelController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let backgroundImage = UIImageView(frame: tableView.bounds)
        //        backgroundImage.image = UIImage(named: "background2")
        //        backgroundImage.alpha = 0.4
        //        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        //        self.tableView.insertSubview(backgroundImage, at: 0)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = self.view.frame.height / 5
        
        
        self.title = "Danh sách khu trọ"
        setupRightButton()
        setupLeftButton()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Store.shared.userMotel.quanlydaytro!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MotelCell") as! MotelCell
        
        let whiteRoundedView = tableView.getSizeCell()
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
        
        if Store.shared.userMotel.quanlydaytro!.count > 0 {
            let motel = Store.shared.userMotel.quanlydaytro![indexPath.row]
            cell.name.text = "Day tro so \(Store.shared.userMotel.quanlydaytro!.count-indexPath.row)"
            cell.numOfRooms.text = String(motel.quanlyphong?.count ?? 0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Store.shared.indexDaytro = indexPath.row
        performSegue(withIdentifier: "FromMotelToListRoom", sender: tableView.cellForRow(at: indexPath))
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            let actionSheet = UIAlertController(title: "Bạn muốn xoá khu trọ này?", message: "Nếu xoá sẽ không thể khôi phục lại dữ liệu của khu trọ này", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Tôi muốn xoá", style: .destructive, handler: { (action) in
                let idDaytro: String = Store.shared.userMotel.quanlydaytro![indexPath.row].iDdaytro!
                Store.shared.userMotel.quanlydaytro?.remove(at: indexPath.row)
//                ListOfMotel.shared.saveDataToFirebase()
                // remove data on firebase
                let uid: String = Auth.auth().currentUser!.uid
                let ref = Database.database().reference().child("User/User2/\(uid)/Quanlydaytro/\(idDaytro)")
                ref.removeValue()
                
                let alert = UIAlertController(title: "Xoá khu trọ thành công", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: { (actionA) in
                    self.tableView.reloadData()
                }))
                self.present(alert, animated: true, completion: nil)
                
            }))
            actionSheet.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
            present(actionSheet, animated: true, completion: nil)
        }
    }
    
    
    func setupRightButton(){
        let infoImage = UIImage(named: "plusicon")
        let imgWidth = infoImage?.size.width
        let imgHeight = infoImage?.size.height
        let button:UIButton = UIButton(frame: CGRect(x: 0,y: 0,width: imgWidth!, height: imgHeight!))
        button.setBackgroundImage(infoImage, for: .normal)
        button.addTarget(self, action: #selector(creatNewMotel), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    func setupLeftButton(){
        let infoImage = UIImage(named: "logout")
        let imgWidth = infoImage?.size.width
        let imgHeight = infoImage?.size.height
        let button:UIButton = UIButton(frame: CGRect(x: 0,y: 0,width: imgWidth!, height: imgHeight!))
        button.setBackgroundImage(infoImage, for: .normal)
        button.addTarget(self, action: #selector(logOut), for: UIControl.Event.touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc func logOut(){
        let alert = UIAlertController(title: "Đăng xuất", message: "Bạn chắc chắn muốn đăng xuất?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Có", style: .destructive, handler: { (action) in
            //            GIDSignIn.sharedInstance()?.signOut()
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            ListOfMotel.shared.removeAll()
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Không", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func creatNewMotel(){
        
        let alert = UIAlertController(title: "Thông báo", message: "Bạn chắc chắn muốn tạo dãy trọ ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.handleCreateMotel()
        }))
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func handleCreateMotel() {
        
        let uid = Auth.auth().currentUser?.uid
        
        let tableName = Database.database().reference().child("User/User2/\(uid!)/Quanlydaytro").childByAutoId()
        
        let daytro: Quanlydaytro = Quanlydaytro.init(idDaytro: tableName.key!, quanlyphong: [])
        
        Store.shared.userMotel.quanlydaytro?.append(daytro)
        
        ListOfMotel.shared.saveDataToFirebase()
        
        let alert = UIAlertController(title: "Tạo khu trọ thành công", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: { (action) in
            self.tableView.reloadData()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromMotelToListRoom" {
            let backItem = UIBarButtonItem()
            backItem.title = "Trở về"
            navigationItem.backBarButtonItem = backItem
        }
    }
}

extension UITableView {
    func getSizeCell()->UIView{
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.frame.size.width - 20, height: self.rowHeight - 16))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.8])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 4.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -2, height: -2)
        
        whiteRoundedView.layer.borderColor = UIColor(displayP3Red: 0, green: 121, blue: 235, alpha: 0.92).cgColor
        
        whiteRoundedView.layer.borderWidth = 2
        whiteRoundedView.layer.shadowOpacity = 0.3
        
        self.separatorColor = UIColor.white
        self.separatorStyle = UITableViewCell.SeparatorStyle.none
        return whiteRoundedView
    }
    
    func getRedBorder()->UIView{
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.frame.size.width - 20, height: self.rowHeight - 16))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.8])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 4.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -2, height: -2)
        
        whiteRoundedView.layer.borderColor = UIColor(displayP3Red: 150, green: 0, blue: 0, alpha: 0.72).cgColor
        
        whiteRoundedView.layer.borderWidth = 2
        whiteRoundedView.layer.shadowOpacity = 0.3
        
        self.separatorColor = UIColor.white
        self.separatorStyle = UITableViewCell.SeparatorStyle.none
        return whiteRoundedView
    }
    
    func getGreenBorder()->UIView{
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.frame.size.width - 20, height: self.rowHeight - 16))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.8])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 4.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -2, height: -2)
        
        whiteRoundedView.layer.borderColor = UIColor(displayP3Red: 0, green: 150, blue: 0, alpha: 0.72).cgColor
        
        whiteRoundedView.layer.borderWidth = 2
        whiteRoundedView.layer.shadowOpacity = 0.3
        
        self.separatorColor = UIColor.white
        self.separatorStyle = UITableViewCell.SeparatorStyle.none
        return whiteRoundedView
    }
}
