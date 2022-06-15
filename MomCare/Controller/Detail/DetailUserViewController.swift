//
//  DetailUserViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 05/07/2021.
//

import UIKit
import Then
import PhotosUI
import RealmSwift

enum UserChoice {
    case mom
    case baby
}

class DetailUserViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var theme: UIImageView!
    
    var model = [DetailModel]()
    var userChoice: UserChoice?
    var currentModel = DetailModel()
    let currentUser = User()
    var saveAdminImage = false
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInfoUser()
        configView()
        setupView()
        setupData()
        changeTheme(self.theme)
        setupNavigationButton()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        changeTheme(theme)
        setupNavigationButton()
        tableView.reloadData()
    }
    
    func setupView() {
        self.title = "Thông tin sản phụ"
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
    
    func setupNavigationButton() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let backItem = UIBarButtonItem(image:  UIImage(named: "ic_left_arrow")?.toHierachicalImage()
                                       , style: .plain, target: self, action: #selector(touchBackButton))
        navigationItem.leftBarButtonItems = [backItem]
        
        let rightItem = UIBarButtonItem(image: UIImage(systemName: "trash")?.toHierachicalImage()
                                        , style: .plain, target: self, action:
                                        #selector(removeUser))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func removeUser() {
        if currentModel.dateSave.isEmpty {
            let alert = UIAlertController(title: "Thông báo", message: "Bệnh nhân chưa được lưu lại", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "Lưu lại", style: .default) { _ in
                self.saveData()
            }
            let cancel = UIAlertAction(title: "Hủy bỏ", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Thông báo", message: "Bạn có muốn xóa bệnh nhân này ?", preferredStyle: .alert)
            let action = UIAlertAction(title: "Đồng ý", style: .default) { _ in
                self.deleteUser()
            }
            let cancel = UIAlertAction(title: "Hủy bỏ", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func deleteUser() {
        let currentUser = realm.objects(User.self).filter("idUser == %@",currentModel.id).toArray()
        let noteOfUser = realm.objects(HistoryNote.self).filter("idUser == %@", currentModel.id).toArray()
        try! realm.write{
            realm.delete(currentUser)
            realm.delete(noteOfUser)
        }
        
        self.navigationController?.popToRootViewController(animated: true)
        Session.shared.isPopToRoot = true
    }
    
    func getInfoUser() {
        guard let data = realm.objects(User.self).filter("idUser == %@", currentModel.id).toArray().first else { return }
        self.currentModel = data.convertToDetailModel()
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
        avatar.avatarImage = currentModel.avatarImage
        
        var general = currentModel
        general.type = .general
        
        var name = currentModel
        name.type = .info
        name.dataType = .name
        name.title = "Họ và tên ⃰"
        name.value = currentModel.name
        
        var address = currentModel
        address.type = .info
        address.dataType = .address
        address.title = "Địa chỉ ⃰"
        address.value = currentModel.address
        
        var momBirth = currentModel
        momBirth.type = .info
        momBirth.dataType = .dob
        momBirth.title = "Năm sinh ⃰"
        momBirth.value = currentModel.momBirth
        
        var number = currentModel
        number.type = .info
        number.dataType = .numberPhone
        number.title = "Số điện thoại ⃰"
        number.value = currentModel.numberPhone
        number.isCall = true
        
        var height = currentModel
        height.type = .info
        height.dataType = .height
        height.title = "Chiều cao ⃰"
        height.value = currentModel.height
        
        var age = currentModel
        age.type = .age
        age.dataType = .babyAge
        age.babyAge = currentModel.babyAge
        
        var note = currentModel
        note.type = .note
        note.dataType = .note
        
        var photo = currentModel
        photo.type = .photo
        photo.dataType = .imagePregnant
        
        var imagePregnant = currentModel
        imagePregnant.type = .imagePregnant
        imagePregnant.dataType = .imagePregnant
        imagePregnant.imagePregnant = currentModel.imagePregnant
        
        model.append(avatar)
        model.append(general)
        model.append(name)
        model.append(address)
        model.append(momBirth)
        model.append(number)
        model.append(height)
        model.append(age)
        model.append(note)
        model.append(photo)
        if currentModel.imagePregnant != nil {
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
        if userChoice == .mom {
            vc.allowsEditing = true
        } else {
            vc.allowsEditing = false
        }
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if userChoice == .mom {
                currentModel.avatarImage = image
                setupData()
                let indexPath = IndexPath(row: 0, section: 0)
                tableView?.reloadRows(at: [indexPath], with: .none)
            } else {
                currentModel.imagePregnant = image
                setupData()
                tableView?.reloadData()
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showMore(_ sender: UIButton) {
        if currentModel.id == "" {
            let alert = UIAlertController(title: "Thông báo", message: "Bệnh nhân chưa được lưu lại", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "Lưu lại", style: .default) { _ in
                self.saveData()
            }
            let cancel = UIAlertAction(title: "Hủy bỏ", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        } else {
            let vc = HistoryViewController.init(nibName: "HistoryViewController", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            vc.idUser = currentModel.id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func saveData(_ sender: UIButton) {
        if currentModel.id != "" {
            updateUser(id: currentModel.id)
        } else {
            saveData()
        }
    }
    
    func saveData() {
        if !currentModel.name.isEmpty && !currentModel.address.isEmpty &&
            !currentModel.momBirth.isEmpty && !currentModel.height.isEmpty && !currentModel.numberPhone.isEmpty {
            saveInfoUser()
        } else {
            let alert = UIAlertController(title: "Thông báo", message: "Đang thiếu thông tin", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "Đã hiểu", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
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
            self?.currentModel.babyAge = date
            self?.calculateBabyAge(dateString: date)
            self?.setupData()
            let indexPath = IndexPath(row: 7, section: 0)
            self?.tableView.reloadRows(at: [indexPath], with: .none)
        }
        present(vc, animated: true, completion: nil)
    }
    
    func calculateBabyAge(dateString: String) {
        let dateFormatter = DateFormatter()
        let todayDate = Date()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from:dateString)
        guard let timeLast = date?.millisecondsSince1970 else { return }
        let timeToday = todayDate.millisecondsSince1970
        let result = timeLast - timeToday
        changeMilisToWeek(milis: result)
    }
    
    func changeMilisToWeek(milis: Int64) {
        let toDay = milis / 86400000
        let ageDay = 280 - Int(toDay)
        let week = Int(ageDay / 7)
        let day = Int(ageDay % 7)
        self.currentModel.dateCalculate = week < 10 ?  "0\(week)W \(day)D" : "\(week)W \(day)D"
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
            cell.setupData(model: currentModel)
            cell.delegate = self
            return cell
        case .general:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GeneralInfoTableViewCell.name, for: indexPath) as?
                    GeneralInfoTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.setupData(currentModel)
            return cell
        case .info:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoUserTableViewCell.name, for: indexPath) as?
                    InfoUserTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.delegate = self
            cell.isAdmin = saveAdminImage
            cell.setupData(model: currentModel)
            cell.invalidPhone = { [weak self] in
                let alert = UIAlertController(title: "Thông báo", message: "Số điện thoại không hợp lệ", preferredStyle: .actionSheet)
                let action = UIAlertAction(title: "Đã hiểu", style: .cancel, handler: nil)
                alert.addAction(action)
                self?.present(alert, animated: true, completion: nil)
            }
            return cell
        case .age:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BaybyAgeTableViewCell.name, for: indexPath) as?
                    BaybyAgeTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.setupData(model: currentModel)
            cell.delegate = self
            return cell
        case .note:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.name, for: indexPath) as?
                    NoteTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.delegate = self
            cell.setupData(model: currentModel)
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagePregnantTableViewCell.name, for: indexPath) as? ImagePregnantTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.setupData(model: currentModel)
            cell.showImage = { [weak self] in
                let vc = ShowImageDetailViewController.init(nibName: "ShowImageDetailViewController", bundle: nil)
                vc.inDetail = true
                vc.imageInDetail = self?.currentModel.imagePregnant
                self?.present(vc, animated: true, completion: nil)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension DetailUserViewController: DetailUserInfo {
    func showAlert(dataType: DataType) {
        var typeCellName = ""
        switch dataType {
        case .name:
            typeCellName = "tên tuổi"
        case .address:
            typeCellName = "địa chỉ"
        case .dob:
            typeCellName = "năm sinh"
        case .numberPhone:
            typeCellName = "số điện thoại"
        case .height:
            typeCellName = "chiều cao"
        default:
            break
        }

        let alert = UIAlertController(title: "Thông báo", message: "Không được bỏ trống \(typeCellName)", preferredStyle: .actionSheet)
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
            currentModel.momBirth = text
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

extension DetailUserViewController {
    func saveInfoUser() {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        do {
            realm.beginWrite()
            currentUser.idUser = NSUUID().uuidString.lowercased()
            currentUser.name = currentModel.name
            currentUser.address = currentModel.address
            currentUser.momBirth = currentModel.momBirth
            currentUser.numberPhone = currentModel.numberPhone
            currentUser.height = currentModel.height
            currentUser.babyDateBorn = currentModel.babyAge
            currentUser.dateSave = dateString
            currentUser.note = currentModel.note
            currentUser.avatar = saveImage(imageName: "avatarUser_\(currentModel.numberPhone)",
                                                image: currentModel.avatarImage ?? UIImage(named: "avatar_placeholder")!,
                                                type: .mom)
            currentUser.imagePregnant = saveImage(imageName: "imagePrgnant_\(currentModel.numberPhone)",
                                                       image: currentModel.imagePregnant ?? nil,
                                                       type: .baby)
            try? realm.commitWrite()
            try? realm.safeWrite({
                realm.add(currentUser)
                let alert = UIAlertController(title: "Thông báo", message: "Lưu thành công", preferredStyle: .actionSheet)
                let action = UIAlertAction(title: "Đã hiểu", style: .cancel) { _ in
                    self.navigationController?.popToRootViewController(animated: true)
                    Session.shared.isPopToRoot = true
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            })
        }
        
    }
    
    func updateUser(id: String) {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        guard let currentUser = realm.objects(User.self).filter("idUser == %@", id).toArray().first else { return }
        
        try! realm.write({
            currentUser.name = currentModel.name
            currentUser.address = currentModel.address
            currentUser.momBirth = currentModel.momBirth
            currentUser.numberPhone = currentModel.numberPhone
            currentUser.height = currentModel.height
            currentUser.babyDateBorn = currentModel.babyAge
            currentUser.dateSave = dateString
            currentUser.note = currentModel.note
            currentUser.avatar = saveImage(imageName: "avatarUser_\(currentModel.numberPhone)",
                                           image: currentModel.avatarImage ?? UIImage(named: "avatar_placeholder")!,
                                           type: .mom)
            currentUser.imagePregnant = saveImage(imageName: "imagePrgnant_\(currentModel.numberPhone)",
                                                  image: currentModel.imagePregnant ?? nil,
                                                  type: .baby)
            
            let alert = UIAlertController(title: "Thông báo", message: "Cập nhật thành công", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "Đã hiểu", style: .cancel) { _ in
                self.navigationController?.popToRootViewController(animated: true)
                Session.shared.isPopToRoot = true
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        })
        
    }
    
}
