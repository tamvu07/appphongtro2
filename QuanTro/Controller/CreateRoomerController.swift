
import UIKit
import MobileCoreServices
import FirebaseStorage
import Firebase
import TextFieldEffects

class CreateRoomerController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {

    
    @IBOutlet weak var nameField: AkiraTextField!
    @IBOutlet weak var dateOfBirthField: AkiraTextField!
    @IBOutlet weak var identifyCardField: AkiraTextField!
    @IBOutlet weak var numPhoneField: AkiraTextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet var addImageButtons: UIButton!
    
    var isCreating:Bool = true
    @objc var image: UIImage?
    @objc var lastChosenMediaType: String?
    var images = [UIImage]()
    var frameForPage = CGRect(x: 0, y: 0, width: 0, height: 0)
    var isAddProfileImage:Bool!
    
    var datePicker:UIDatePicker!
    
    var indexRoomer:Int!
    
    let daytro: Quanlydaytro = Store.shared.userMotel.quanlydaytro![Store.shared.indexDaytro]
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        setupUI()
        if isCreating{
            createButton.setTitle("Tạo người trọ", for: .normal)
        }else{
            createButton.setTitle("Cập nhật", for: .normal)
            setupInfo()
        }
        self.title = "Thông tin người trọ"
        
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "vi")
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateDisplay()
        if images.count == 0{
            return
        }
//        setupScrollView()
        
    }
    
    func setupUI(){
        createButton.layer.cornerRadius = 5
        createButton.layer.shadowOpacity = 1
        addImageButtons.layer.cornerRadius = 3
        addImageButtons.layer.shadowOpacity = 1
    }
    
    @IBAction func createButtonOnPressed(_ sender: Any) {
        if nameField.text?.isEmpty == true || dateOfBirthField.text?.isEmpty == true || identifyCardField.text?.isEmpty == true || numPhoneField.text?.isEmpty == true || profileImageView.image == nil {
            let alert = UIAlertController(title: "Thiếu thông tin", message: "Bạn cần điền đầy đủ thông tin và thêm đủ hình", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        isCreating ? handleCreating():handleUpdating()
    }
    
    func handleCreating(){
        let uid: String = Auth.auth().currentUser!.uid
        let idDaytro: String = daytro.iDdaytro!
        let idPhong: String = daytro.quanlyphong![Store.shared.indexPhongtro].iDphong!
        
        let tableName  = Database.database().reference().child("User/User2/\(uid)/Quanlydaytro/\(idDaytro)/Quanlyphong/\(idPhong)/Quanlythanhvien").childByAutoId()
        
        var newRoomer: ThanhVien = ThanhVien.init(idThanhVien: "", ten: "", ngaysinh: "", cmnd: 0, sdt: 0, avatar: "")
        
        newRoomer.ten = nameField.text
        newRoomer.ngaysinh = dateOfBirthField.text
        newRoomer.cmnd = NumberFormatter().number(from: identifyCardField.text!)?.doubleValue
        newRoomer.sdt = NumberFormatter().number(from: numPhoneField.text!)?.doubleValue
        newRoomer.idThanhVien = tableName.key
        
        let idImage: String = String.init(format: "%.0f", newRoomer.cmnd!)
        
        let idThanhvien: String = newRoomer.idThanhVien!
        let storageRef = Storage.storage().reference().child("imagesOfRoomer/\(idThanhvien)/\(idImage).jpg")
        let data = profileImageView.image?.jpegData(compressionQuality: 1)
        if data != nil{
            storageRef.putData(data!, metadata: nil) { (metadata, error) in
                if error != nil{
                    print(error!)
                    return
                }
            }
            newRoomer.avatar = "\(idImage).jpg"
        }
        
//        ListOfMotel.shared.addRoomer(newRoomer: newRoomer)
//        ListOfMotel.shared.saveDataToFirebase()

        Store.shared.userMotel.quanlydaytro![Store.shared.indexDaytro].quanlyphong![Store.shared.indexPhongtro].thanhvien?.append(newRoomer)
        
        let addNewRoomer: [String:Any] = [
            "Ten": newRoomer.ten!,
            "Ngaysinh": newRoomer.ngaysinh!,
            "CMND": newRoomer.cmnd!,
            "SDT": newRoomer.sdt!,
            "Avatar": newRoomer.avatar as Any
        ]
        
        tableName.setValue(addNewRoomer)
        
        let alert = UIAlertController(title: "Tạo người trọ thành công ", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: { (action) in
            let songuoidangthue: Int = (self.daytro.quanlyphong![Store.shared.indexPhongtro].chitietphong?.songuoidangthue!)! + 1
            let updateDataPhong: [String:Any] = ["Songuoidangthue": songuoidangthue]
            Database.database().reference().child("User/User2/\(uid)/Quanlydaytro/\(idDaytro)/Quanlyphong/\(idPhong)/Chitietphong").updateChildValues(updateDataPhong)
            
            Store.shared.userMotel.quanlydaytro![Store.shared.indexDaytro].quanlyphong![Store.shared.indexPhongtro].chitietphong?.songuoidangthue = songuoidangthue
            
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
        
    }
    
    func handleUpdating(){
        var currentRoomer: ThanhVien = daytro.quanlyphong![Store.shared.indexPhongtro].thanhvien![Store.shared.indexRoomer]
        currentRoomer.ten = nameField.text
        currentRoomer.ngaysinh = dateOfBirthField.text
        currentRoomer.cmnd = NumberFormatter().number(from: identifyCardField.text!)?.doubleValue
        currentRoomer.sdt = NumberFormatter().number(from: numPhoneField.text!)?.doubleValue
        
        let idImage:String = String.init(format: "%.0f", currentRoomer.cmnd!)
        let idThanhVien: String = currentRoomer.idThanhVien!
        
        let storageRef = Storage.storage().reference().child("imagesOfRoomer/\(idThanhVien)/\(idImage).jpg")
        let data = profileImageView.image?.jpegData(compressionQuality: 1)
        if data != nil{
            storageRef.putData(data!, metadata: nil) { (metadata, error) in
                if error != nil{
                    print(error!)
                    return
                }
            }
            currentRoomer.avatar = "\(idImage).jpg"
        }
//        ListOfMotel.shared.updateRoomer(withIndex: indexRoomer, roomer: currentRoomer)
//        ListOfMotel.shared.saveDataToFirebase()
        
        Store.shared.userMotel.quanlydaytro![Store.shared.indexDaytro].quanlyphong![Store.shared.indexPhongtro].thanhvien![Store.shared.indexRoomer] = currentRoomer
        
        let uid: String = Auth.auth().currentUser!.uid
        let idDaytro: String = daytro.iDdaytro!
        let idPhong: String = daytro.quanlyphong![Store.shared.indexPhongtro].iDphong!
        
        let updateRoomer: [String:Any] = [
            "Ten": currentRoomer.ten!,
            "Ngaysinh": currentRoomer.ngaysinh!,
            "CMND": currentRoomer.cmnd!,
            "SDT": currentRoomer.sdt!,
            "Avatar": currentRoomer.avatar as Any
        ]
        Database.database().reference().child("User/User2/\(uid)/Quanlydaytro/\(idDaytro)/Quanlyphong/\(idPhong)/Quanlythanhvien/\(idThanhVien)").setValue(updateRoomer)
        
        
        let alert = UIAlertController(title: "Cập nhật thành công", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func dateOfBirthFieldBeginEditting(_ sender: Any) {
        dateOfBirthField.inputView = datePicker
        dateOfBirthField.inputAccessoryView = setupToolBar()
    }
    
    @IBAction func closeKeyboard(_ sender: Any) {
        cancelClick()
    }
    
    
    func setupToolBar()->UIToolbar{
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 199/255, green: 90/255, blue: 90/255, alpha: 1)
        toolBar.sizeToFit()
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Chọn", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Huỷ", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    @objc func doneClick(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        switch true {
        case dateOfBirthField.isEditing:
            dateOfBirthField.text = dateFormatter.string(from: datePicker.date)
        default:
            break
        }
        cancelClick()
        
    }
    
    @objc func cancelClick(){
        nameField.resignFirstResponder()
        identifyCardField.resignFirstResponder()
        numPhoneField.resignFirstResponder()
        dateOfBirthField.resignFirstResponder()
    }
    
    func showActionSheet(){
        let actionSheet = UIAlertController(title: "Chọn ảnh", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Thư viện ảnh", style: .default, handler: { (action) in
            self.pickMediaFromSource(UIImagePickerController.SourceType.photoLibrary)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Chụp ảnh", style: .default, handler: { (action) in
            self.pickMediaFromSource(UIImagePickerController.SourceType.camera)
        }))
        actionSheet.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    //MARK: Setup frame of scollView and UIScrollViewDelegate
//    func setupScrollView(){
//        scrollView.isHidden = false
//        page.isHidden = false
//
//        page.numberOfPages = images.count
//        for i in 0..<images.count{
//            frameForPage.origin.x = scrollView.frame.size.width * CGFloat(i)
//            frameForPage.size = scrollView.frame.size
//            let imageV = UIImageView(frame: frameForPage)
//            imageV.image = images[i]
//            scrollView.addSubview(imageV)
//        }
//        scrollView.contentSize = CGSize(width: (scrollView.frame.width * CGFloat(images.count)), height: scrollView.frame.height)
//        scrollView.delegate = self
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
//        page.currentPage = Int(pageNumber)
//    }
    
    
    //MARK: Setup UIImagePickerDelegate
    @objc func updateDisplay() {
        if let mediaType = lastChosenMediaType {
            if mediaType == (kUTTypeImage as NSString) as String {
                if isAddProfileImage{
                    profileImageView.image = image
                }else{
                    images.append(image!)
                }
            }
        }
        lastChosenMediaType = nil
        image = nil
    }
    
    @objc func pickMediaFromSource(_ sourceType:UIImagePickerController.SourceType) {
        let mediaTypes =
            UIImagePickerController.availableMediaTypes(for: sourceType)!
        if UIImagePickerController.isSourceTypeAvailable(sourceType)
            && mediaTypes.count > 0 {
            let picker = UIImagePickerController()
            
            picker.mediaTypes = mediaTypes
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = sourceType
            present(picker, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title:"Error accessing media",
                                                    message: "Unsupported media source.",
                                                    preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: UIAlertAction.Style.cancel, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        lastChosenMediaType = info[UIImagePickerController.InfoKey.mediaType] as? String
        if let mediaType = lastChosenMediaType {
            if mediaType == (kUTTypeImage as NSString) as String {
                image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
    
    @IBAction func tapGestureRecognized(_ sender: Any) {
        nameField.resignFirstResponder()
        dateOfBirthField.resignFirstResponder()
        identifyCardField.resignFirstResponder()
        numPhoneField.resignFirstResponder()
    }
    
    @IBAction func addProfileImage(_ sender: Any) {
        isAddProfileImage = true
        showActionSheet()
    }
    
//    @IBAction func addIdentifyCardImage(_ sender: Any) {
//        isAddProfileImage = false
//        showActionSheet()
//    }
    
    func setupInfo(){
        let currentRoomer: ThanhVien = daytro.quanlyphong![Store.shared.indexPhongtro].thanhvien![Store.shared.indexRoomer]
        nameField.text = currentRoomer.ten
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateOfBirthField.text = currentRoomer.ngaysinh
        identifyCardField.text = String.init(format: "%.0f", currentRoomer.cmnd!)
        numPhoneField.text = String.init(format: "%.0f", currentRoomer.sdt!)
        
        let idImage:String = String.init(format: "%.0f", currentRoomer.cmnd!)
        let idThanhVien: String = currentRoomer.idThanhVien!
        
        if let _ = currentRoomer.avatar {
            let storageRef = Storage.storage().reference().child("imagesOfRoomer/\(idThanhVien)/\(idImage).jpg")
            storageRef.getData(maxSize: 4*1024*1024) { (data, error) in
                if error != nil{
                    print(error!)
                    self.profileImageView.image = UIImage.init(named: "person")
                }else{
                    DispatchQueue.main.async{
                        self.profileImageView.image = UIImage(data: data!)!
                    }
                }
                
            }
        }
        else {
            self.profileImageView.image = UIImage.init(named: "person")
        }
        
//        for imageString in currentRoomer.identityImageString{
//            let storageRef = Storage.storage().reference().child("imagesOfMotels/\(imageString)")
//            storageRef.getData(maxSize: 3*1024*1024) { (data, error) in
//                if error != nil{
//                    print(error!)
//                }else{
//                    self.images.append(UIImage(data: data!)!)
//                    if self.images.count == currentRoomer.identityImageString.count{
//                        DispatchQueue.main.async {
////                            self.setupScrollView()
//                        }
//
//                    }
//                }
//
//            }
//        }
    }
}
