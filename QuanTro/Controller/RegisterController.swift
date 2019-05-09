
import UIKit
import Firebase
//import GoogleSignIn
import TextFieldEffects
import DLRadioButton
import FirebaseAuth
import FirebaseStorage
var quyenUser:Int!


class RegisterController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var usernameFiled: AkiraTextField!
    @IBOutlet weak var passwordField: AkiraTextField!
    @IBOutlet weak var confirmField: AkiraTextField!
    @IBOutlet weak var register_custom: UIButton!
    var RadioButtonValue:String!
  
    var imgdata:Data!
    @IBOutlet weak var avatar: UIImageView!
    
    
    var handle:AuthStateDidChangeListenerHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        avatar.isUserInteractionEnabled = true
        let TapGesture =  UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.avatar.addGestureRecognizer(TapGesture)
        // khi moi vao co anh tu may luon
        imgdata = UIImage(named: "person")!.pngData()
    }
    
     @objc func handleTap(_ sender: UITapGestureRecognizer){
//        let alert = UIAlertController(title: "image", message: "image change", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: {Action in
//            self.avatar.image = UIImage(named: "motorcycle")
//        })
//        alert.addAction(okAction)
//        self.present(alert, animated: true, completion: nil)
        
        let alert:UIAlertController = UIAlertController(title: "thong bao", message: "chon", preferredStyle: .alert)
        // tao ra 2 button
        let btphoto:UIAlertAction = UIAlertAction(title: "pho to", style: .default) { (UIAlertAction) in
            // chon vao thu muc anh va lay anh o thu vien
            let ImgPicker = UIImagePickerController()
            ImgPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            ImgPicker.delegate = self
            // khong cho thay doi anh
            ImgPicker.allowsEditing = false
            // nho man hinh chinh truy cap den no
            self.present(ImgPicker, animated: true, completion: nil)
        }
        
        let btcamera:UIAlertAction = UIAlertAction(title: "camera", style: .default) { (UIAlertAction) in
            // kiem tra xem co camera khong
            if(UIImagePickerController.isSourceTypeAvailable(.camera))
            {
                let ImgPicker = UIImagePickerController()
                ImgPicker.sourceType = UIImagePickerController.SourceType.camera
                ImgPicker.delegate = self
                // khong cho thay doi anh
                ImgPicker.allowsEditing = false
                // nho man hinh chinh truy cap den no
                self.present(ImgPicker, animated: true, completion: nil)
            }
            else
            {
                print("khong co camera......!")
            }
        }
        
        alert.addAction(btphoto)
        alert.addAction(btcamera)
        // phai dong no len
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // khi vao camera hay photo thi goi den ham nay
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // chua biet no tra ve kieu gi nen ap ve UIImage
        let chooseimage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        // giam do phan giai cua tam hinh
        // lay ra gia tri nao cao nhat
        let imgvalue = max(chooseimage.size.width,chooseimage.size.height)
        if(imgvalue > 3000)
        {
            // giam do phan giai tam hinh xuong 0.1
            imgdata = chooseimage.jpegData(compressionQuality: 0.1)
        }
        else if(imgvalue > 2000)
        {
            // giam do phan giai tam hinh xuong 0.1
            imgdata = chooseimage.jpegData(compressionQuality: 0.3)
        }
        else
        {
            imgdata = chooseimage.pngData()
        }
        // truyen tam hinh moi lay vao UIImageView
        avatar.image = UIImage(data: imgdata)
        // sau do dong hop thoai lai
        dismiss(animated: true, completion: nil)
    }
    
    //radio button
    @objc @IBAction private func logSelectedButton(_ radioButton : DLRadioButton) {
        if (radioButton.isMultipleSelectionEnabled) {
            for button in radioButton.selectedButtons() {
                print(String(format: "%@ is selected ha .\n", button.titleLabel!.text!));
            }
        } else {
            RadioButtonValue = radioButton.selected()?.titleLabel?.text!
//            print(String(format: "%@ is selected.\n", RadioButtonValue));
            let x:String = String(format: "%@", RadioButtonValue);
            if(x == "khach hang")
            {
                quyenUser = 1
            }else
            if(x == "chu phong")
            {
                quyenUser = 2
            }

//            print(".........\(String(describing: quyenUser))..........")
        }
    }
    
    
    @IBAction func tap_Gesture_avatar(_ sender: UITapGestureRecognizer) {
        print("co ok ne !")
    }
    
    
    @IBAction func bt_register(_ sender: Any) {
        let email:String = usernameFiled.text!
        let pass:String = passwordField.text!
        let repass:String = confirmField.text!
        
        if(email == "" || pass == "" || repass == "")
        {
            let alert = UIAlertController(title: "Thông Báo", message: "Vui Lòng Nhập Đủ Thông Tin", preferredStyle: .alert)
            let bt_ok:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(bt_ok)
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            // tao tai khoan
            Auth.auth().createUser(withEmail: email, password: pass) { authResult, error in
                if(error == nil)
                {
//
//                    // dang ky xong ma ko co loi thi cho dang nhap luon
//                    Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
//                        if(error == nil)
//                        {
//                            print("ok dang nhap thanh cong !")
//                            // luu user len databse va kiem tra la user la ai
//                        }
//                    }
                    
                    // dua avatar len database khi dang ky
                    let Avatar_Ref = storageRef.child("images/\(email).jpg")
                    // Upload the file to the path "images/rivers.jpg"
                    let uploadTask = Avatar_Ref.putData(self.imgdata, metadata: nil) { (metadata, error) in
                        guard let metadata = metadata else {
                            print("loi up load lan 1")
                            return
                        }
                        // Metadata contains file metadata such as size, content-type.
                        let size = metadata.size
                        // You can also access to download URL after upload.
                        Avatar_Ref.downloadURL { (url, error) in
                            guard let downloadURL = url else {
                                print("loi up load lan 2")
                                return
                            }
                            
                            // cah de luu ten va tam hinh len firebase
                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            changeRequest?.photoURL = downloadURL
                            changeRequest?.commitChanges { (error) in
                                if let error = error{
                                    print("loi upload profile")
                                }else{
                                        print("dang ky thanh cong ...... chuyen trang ! \n")
                                    // dang ky xong ma ko co loi thi cho dang nhap luon
                                    Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                                        if(error == nil)
                                        {
                                            print("ok dang nhap thanh cong !")
                                            
                                            let f = chucnang()
                                            let q = f.kiemraUser_addUser()
                                            if(q == 1)
                                            {
                                                self.goto_Screen_Main_khach_hang()
                                            }else if(q == 2)
                                                    {
                                                       print("di den man hinh chu phong")
                                                    }
//                                            // tao tai khoan thanh cong thi se luu thong tin nguoi dung vao database
//                                            let user = Auth.auth().currentUser
//                                            if let user = user {
//                                                let uid = user.uid
//                                                let email = user.email
//                                                let photoURL = user.photoURL
//                                                let quyen = quyenUser
//
//                                                //                        currenUser = User(id: uid, email: email!, fullname: name!, linkAvatar: String("\(photoURL!)") )
//                                                currenUser = User(id: uid, email: email!, linkAvatar: String("\(photoURL!)") , quyen: quyen!)
//                                                //            print("...........<<<<\(currenUser.linkAvatar)>>>>..............")
//                                                var u = ""
//                                                var ql = "Quanlydaytro"
//                                                var DSP = "Danhsachphong"
//                                                var CTP = "Chitietphong"
//                                                if(currenUser.quyen == 1)
//                                                {
//                                                     u = "User1"
//                                                }else
//                                                {
//                                                    u = "User2"
//                                                }
//                                                let tableUser = ref.child("User").child("\(u)").child(currenUser.id).child("\(ql)").child("\(DSP)").childByAutoId().child("ctp")
////                                                // lay id user dang dang nhap hien tai
////                                                let userid = tableUser.child(currenUser.id)
//                                                // khoi tao 1 user de up len fire base
//                                                let chitietphong:Dictionary<String,String> = ["Dientich":currenUser.email,
//                                                                                              "Gia":String (currenUser!.quyen),
//                                                                                              "Motacuthe":currenUser.linkAvatar,
//                                                                                              "hinhphong": ,
//                                                                                              "Diachi": ,
//                                                                                              "Trangthai":
//                                                ]
//                                                userid.setValue(user)
//                                                let url:URL = URL(string: currenUser.linkAvatar)!
//                                                do{
//                                                    let data:Data = try Data(contentsOf: url)
//                                                    currenUser.Avatar = UIImage(data: data)
//                                                    // dem du lieu len fire base database
////                                                    print("...xxxxx..<<<<\(currenUser.email)>>>>......\(currenUser.quyen)...........")
//                                                    let currenUser_quyen:Int = currenUser.quyen
//                                                    if(currenUser_quyen == 1)
//                                                    {
//                                                        self.goto_Screen_Main_khach_hang()
//                                                    }
//                                                }
//                                                catch{
//                                                    print("loi load hinh")
//                                                }
//
//                                        }
//                                        else
//                                        {
//                                            print("khong co user !.............")
//                                        }

                                            }
                                        }

                                }
                            }
                        }
                    }
                    // de up load file len phai chay lenh uploadTask.resume()
                    uploadTask.resume()
                    
                }
                else
                {
                    let alert = UIAlertController(title: "Thông Báo", message: "Lỗi Đăng Ký", preferredStyle: .alert)
                    let bt_ok:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(bt_ok)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
//
//        }
//    }
//    override func viewDidDisappear(_ animated: Bool) {
//
//        Auth.auth().removeStateDidChangeListener(handle)
//    }
   
    func setupView(){
        
        self.title = "Đăng kí tài khoản"
        
        usernameFiled.setupUI()
        passwordField.setupUI()
        confirmField.setupUI()
        register_custom.layer.cornerRadius = 5
        register_custom.layer.shadowOpacity = 2
    }
    
//    @IBAction func createAccount(_ sender: Any) {
//        guard let username = usernameFiled.text, let password = passwordField.text, let confirm = confirmField.text else{return}
//
//        if password == confirm {
//            Auth.auth().createUser(withEmail: username, password: password) { (authResult, error) in
//                if let error = error {
//                    let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: nil))
//                    self.present(alert, animated: true, completion: {
//                        return
//                    })
//                    return
//                }
//
//                guard let uid = authResult?.user.uid, let email = authResult?.user.email else{
//                    return
//                }
//
//                let ref = Database.database().reference(fromURL: "https://quantro-faf83.firebaseio.com/")
//                let userRef = ref.child("user").child(uid)
//
//                let values = ["email":email]
//                userRef.updateChildValues(values as [AnyHashable : Any], withCompletionBlock: { (error, ref) in
//                    if error != nil{
//                        return
//                    }
//
//                })
//
//
//                let alert = UIAlertController(title: "", message: "Tạo tài khoản thành côn ", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: {action in self.navigationController?.popViewController(animated: true)}))
//                self.present(alert, animated: true, completion: nil)
//
//            }
//        }else{
//            let alert = UIAlertController(title: "", message: "Password không trùng nhau", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: {
//                return
//            })
//        }
//
//
//    }
    
    func closeKeyBoard(){
        usernameFiled.resignFirstResponder()
        passwordField.resignFirstResponder()
        confirmField.resignFirstResponder()
    }
    
    @IBAction func tapGesture(_ sender: Any) {
        closeKeyBoard()
    }
    
    @IBAction func enterToCloseKeyboard(_ sender: Any) {
        closeKeyBoard()
    }
    
    func goto_Screen_Main_khach_hang() {
        let scr = self.storyboard?.instantiateViewController(withIdentifier: "MH_chucnang_khachhang")
        present(scr!, animated: true, completion: nil)
    }
    
}
