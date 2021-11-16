//
//  DetailUserViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 05/07/2021.
//

import UIKit
import Then
import RealmSwift
import PhotosUI

enum UserChoice {
    case mom
    case baby
}

class DetailUserViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    
    var model = [DetailModel]()
    let user = User()
    var avatarImage = UIImage(named: "avatar_placeholder")
    var babyImage: UIImage? {
        didSet {
            setupData()
        }
    }
    var userChoice: UserChoice?
    var momDob = ""
    var babyDob = ""
    var currentModel = DetailModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        setupData()
        setupBackButton()
        self.title = "Thông tin bệnh nhân"
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.bottomHeightConstraint.constant = keyboardHeight - 18
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomHeightConstraint.constant = 16
        self.view.layoutIfNeeded()
    }
    
    func setupBackButton() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let backItem = UIBarButtonItem(image:  UIImage(named: "ic_left_arrow"), style: .plain, target: self, action: #selector(touchBackButton))
        navigationItem.leftBarButtonItems = [backItem]
    }
    
    @objc func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.tableFooterView = UIView()
            $0.separatorStyle = .none
            $0.registerNibCellFor(type: AvatarUserTableViewCell.self)
            $0.registerNibCellFor(type: GeneralInfoTableViewCell.self)
            $0.registerNibCellFor(type: InfoUserTableViewCell.self)
            $0.registerNibCellFor(type: BaybyAgeTableViewCell.self)
            $0.registerNibCellFor(type: NoteTableViewCell.self)
            $0.registerNibCellFor(type: PhotoTableViewCell.self)
            $0.registerNibCellFor(type: ImagePregnantTableViewCell.self)
        }
    }
    
    func setupData() {
        model.removeAll()
        var avatar = currentModel
        avatar.type = .avatar
        avatar.dataType = .momImage
        
        var general = currentModel
        general.type = .general
        
        var name = currentModel
        name.type = .info
        name.dataType = .name
        name.title = "Họ và tên"
        name.value = currentModel.name
        
        var address = currentModel
        address.type = .info
        address.dataType = .address
        address.title = "Địa chỉ"
        address.value = currentModel.address
        
        var birth = currentModel
        birth.type = .info
        birth.dataType = .dob
        birth.title = "Năm sinh"
        birth.value = currentModel.dob
        
        var number = currentModel
        number.type = .info
        number.dataType = .numberPhone
        number.title = "Số điện thoại"
        birth.value = currentModel.numberPhone
        
        var height = currentModel
        height.type = .info
        height.dataType = .height
        height.title = "Chiều cao"
        height.value = currentModel.height
        
        var age = currentModel
        age.type = .age
        age.dataType = .babyAge
        
        var note = currentModel
        note.type = .note
        note.dataType = .note
        
        var photo = currentModel
        photo.type = .photo
        photo.dataType = .imagePregnant
        
        var imagePregnant = currentModel
        imagePregnant.type = .imagePregnant
        imagePregnant.dataType = .imagePregnant
        
        model.append(avatar)
        model.append(general)
        model.append(name)
        model.append(address)
        model.append(birth)
        model.append(number)
        model.append(height)
        model.append(age)
        model.append(note)
        model.append(photo)
        if self.babyImage != nil {
            model.append(imagePregnant)
        }
    }
    
    func modelIndexPath(indexPath: IndexPath) -> DetailModel {
        return model[indexPath.row]
    }
    
    private func openLibararies() {
        let alert = UIAlertController(title: "Select Photo Type".localized, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Photo Library".localized, style: .default , handler:{ (UIAlertAction)in
            self.openMedia(type: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Camera".localized, style: .default , handler:{ (UIAlertAction)in
            self.openMedia(type: .camera)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    private func openMedia(type: UIImagePickerController.SourceType) {
        let vc = UIImagePickerController()
        vc.sourceType = type
        vc.videoQuality = .typeMedium
        vc.allowsEditing = false
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            if image.pngData()?.count ?? 0 >= 12000 * 1000 {
//                self.view.makeToast("Lỗi tải ảnh: Ảnh của bạn có thể sẽ bị thay đổi kích thước do vượt quá dung lượng (5MB).", duration: 1.5, position: .top)
//            }
            guard let imgData = image.jpegData(compressionQuality: 0.9) else { return }
            let data = NSData(data: imgData)
            if userChoice == .mom {
                self.avatarImage = image
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView?.reloadRows(at: [indexPath], with: .none)
            } else {
                self.babyImage = image
                self.tableView?.reloadData()
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }

    @IBAction func showMore(_ sender: UIButton) {
        let vc = HistoryViewController.init(nibName: "HistoryViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func saveData(_ sender: UIButton) {
    }
    
    func openDate() {
        let vc = PopupCalendarViewController.init(nibName: "PopupCalendarViewController", bundle: nil)
        vc.openCalendar = { [weak self] in
            self?.view.alpha = 0.5
            self?.navigationController?.navigationBar.alpha = 0.3
        }
        vc.closeCalendar = { [weak self] in
            self?.view.alpha = 1
            self?.navigationController?.navigationBar.alpha = 1
        }
        
        vc.selectDate = { [weak self] date in
            switch self?.userChoice {
            case .baby:
                self?.babyDob = date
       //         self?.saveDate(date: date)
            default:
                break
            }
            let indexPath = IndexPath(row: 7, section: 0)
            self?.tableView.reloadRows(at: [indexPath], with: .none)
        }
        present(vc, animated: true, completion: nil)
    }
    
    func saveAvatar(image: NSData) {
        let realm = try! Realm()
        user.momImage = image
        
        try! realm.write({
            realm.add(user)
        })
    }
    
    func saveBabyImage(image: NSData) {
        let realm = try! Realm()
        user.babyImage = image
        try! realm.write({
            realm.add(user)
        })
    }
    
    func saveDate(date: String) {
        let realm = try! Realm()
        if userChoice == .mom {
            user.dob = date
        } else {
            user.dateCalculate = date
        }
        try! realm.write({
            realm.add(user)
        })
    }
    
    func saveInfoUser(model: DataType, text: String) {
        let realm = try! Realm()
        switch model {
        case .name:
            user.name = text
        case .address:
            user.address = text
        case .numberPhone:
            user.numberPhone = text
        case .height:
            user.height = text
        case .note:
            if text.count > 0 {
                user.note = text
            } else {
                user.note = ""
            }
        case .dateSave:
            user.dateSave = text
        default:
            break
        }
        try! realm.write({
            realm.add(user)
        })
    }
}

extension DetailUserViewController: UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.currentModel = modelIndexPath(indexPath: indexPath)
        
        switch currentModel.type {
        case .avatar:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AvatarUserTableViewCell.name, for: indexPath) as?
                    AvatarUserTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            if currentModel.avatarImage == nil {
                currentModel.avatarImage = self.avatarImage
            }
            cell.setupData(model: currentModel)
            cell.delegate = self
            return cell
        case .general:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GeneralInfoTableViewCell.name, for: indexPath) as?
                    GeneralInfoTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            return cell
        case .info:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoUserTableViewCell.name, for: indexPath) as?
                    InfoUserTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.delegate = self
            cell.setupData(model: currentModel)
            return cell
        case .age:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BaybyAgeTableViewCell.name, for: indexPath) as?
                    BaybyAgeTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            if currentModel.babyAge.isEmpty {
                currentModel.babyAge = self.babyDob
            }
            cell.setupData(model: currentModel)
            cell.delegate = self
            return cell
        case .note:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.name, for: indexPath) as?
                    NoteTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.changeHeightCell = { [weak self] in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
            }
            return cell
        case .photo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.name, for: indexPath) as?
                    PhotoTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        case .imagePregnant:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagePregnantTableViewCell.name, for: indexPath) as?
                    ImagePregnantTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            if currentModel.babyImage == nil {
                currentModel.babyImage = self.babyImage
            }
            cell.setupData(model: currentModel)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension DetailUserViewController: DetailUserInfo {
    func saveNote(text: String) {
//       saveInfoUser(model: .note, text: text)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Thông báo", message: "Không được bỏ trống trường này", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Đã hiểu", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendString(dataType: DataType, text: String) {
        switch dataType {
        case .name:
            currentModel.name = text
        case .address:
            currentModel.address = text
        case .dob:
            currentModel.dob = text
        case .numberPhone:
            currentModel.numberPhone = text
        case .height:
            currentModel.height = text
        case .babyAge:
            currentModel.babyAge = text
        case .dateCalculate:
            currentModel.dateCalculate = text
        case .note:
            currentModel.note = text
        default:
            break
        }
        self.setupData()
    }
    
    func chooseAvatar() {
        userChoice = .mom
        openLibararies()
    }
    
    func chooseBabyDOB() {
        userChoice = .baby
        openDate()
    }
    
    func chooseImage() {
        userChoice = .baby
        openLibararies()
    }
}
