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
    @IBOutlet weak var saveButton: UIButton!
    
    var model = [DetailModel]()
    var userChoice: UserChoice?
    var currentModel = DetailModel()
    let currentUser = User()
    let realm = try! Realm()
    let asyncMainThread = DispatchQueue.main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.Text.patientInfo
        self.getInfoUser()
        self.asyncMainThread.async {
            self.changeTheme(self.theme)
            self.setupView()
        }
        self.configView()
        self.setupData()
        self.setupNavigationButton()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.changeTheme(theme)
        self.setupNavigationButton()
        self.tableView.reloadData()
    }
    
    func setupView() {
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
        self.bottomHeightConstraint.constant = 16
        self.view.layoutIfNeeded()
    }
    
    func setupNavigationButton() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let backItem = UIBarButtonItem(image:  UIImage(named: Constant.Text.icBack)?.toHierachicalImage()
                                       , style: .plain, target: self, action: #selector(touchBackButton))
        navigationItem.leftBarButtonItems = [backItem]
        
        let rightItem = UIBarButtonItem(image: !currentModel.dateSave.isEmpty ?
                                        UIImage(systemName: Constant.Text.icTrash)?.toHierachicalImage() : UIImage(systemName: Constant.Text.icTrash)
                                        , style: .plain, target: self, action:
                                        #selector(removeUser))
        rightItem.isEnabled = !currentModel.dateSave.isEmpty
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func removeUser() {
        if self.currentModel.dateSave.isEmpty {
            let alert = UIAlertController(title: Constant.Text.notification, message: Constant.Text.patientNotSave, preferredStyle: .actionSheet)
            let action = UIAlertAction(title: Constant.Text.saveIt, style: .default) { _ in
                self.saveData()
            }
            let cancel = UIAlertAction(title: Constant.Text.cancel, style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: Constant.Text.notification, message: Constant.Text.removeUser, preferredStyle: .alert)
            let action = UIAlertAction(title: Constant.Text.accept, style: .default) { _ in
                self.deleteUser()
            }
            let cancel = UIAlertAction(title: Constant.Text.cancel, style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func deleteUser() {
        let currentUser = realm.objects(User.self).filter("idUser == %@",currentModel.id).toArray()
        let noteOfUser = realm.objects(HistoryNote.self).filter("idUser == %@", currentModel.id).toArray()
        try! self.realm.write{
            self.realm.delete(currentUser)
            self.realm.delete(noteOfUser)
        }
        
        self.navigationController?.popToRootViewController(animated: true)
        Session.shared.isPopToRoot = true
    }
    
    func getInfoUser() {
        guard let data = realm.objects(User.self).filter("idUser == %@", currentModel.id).toArray().first else { return }
        self.currentModel = data.convertToDetailModel()
    }
        
    func configView() {
        self.tableView.do {
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
        self.currentModel.dateSave.isEmpty ? self.saveButton.setTitle(Constant.Text.save, for: .normal) : self.saveButton.setTitle(Constant.Text.saveChange, for: .normal)
    }
    
    func setupData() {
        self.model.removeAll()
        var avatar = currentModel
        avatar.type = .avatar
        avatar.dataType = .momImage
        avatar.avatarImagePath = currentModel.avatarImagePath
        
        var general = currentModel
        general.type = .general
        
        var name = currentModel
        name.type = .info
        name.dataType = .name
        name.title = Constant.Text.name
        name.value = currentModel.name
        
        var address = currentModel
        address.type = .info
        address.dataType = .address
        address.title = Constant.Text.address
        address.value = currentModel.address
        
        var momBirth = currentModel
        momBirth.type = .info
        momBirth.dataType = .dob
        momBirth.title = Constant.Text.yearBorn
        momBirth.value = currentModel.momBirth
        
        var number = currentModel
        number.type = .info
        number.dataType = .numberPhone
        number.title = Constant.Text.phone
        number.value = currentModel.numberPhone
        number.isCall = true
        
        var height = currentModel
        height.type = .info
        height.dataType = .height
        height.title = Constant.Text.height
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
        imagePregnant.imagePregnantPath = currentModel.imagePregnantPath
        
        self.model.append(avatar)
        self.model.append(general)
        self.model.append(name)
        self.model.append(address)
        self.model.append(momBirth)
        self.model.append(number)
        self.model.append(height)
        self.model.append(age)
        self.model.append(note)
        self.model.append(photo)
        if !self.currentModel.imagePregnantPath.isEmpty || self.currentModel.imagePregnant != nil {
            self.model.append(imagePregnant)
        }
    }
    
    func modelIndexPath(indexPath: IndexPath) -> DetailModel {
        return self.model[indexPath.row]
    }
    
    private func openLibararies() {
        let alert = UIAlertController(title: "Select Photo Type", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default , handler:{ (UIAlertAction)in
            self.openMedia(type: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            self.openMedia(type: .camera)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
        }))
        
        self.present(alert, animated: true, completion: {
        })
    }
    
    private func openMedia(type: UIImagePickerController.SourceType) {
        let vc = UIImagePickerController()
        vc.sourceType = type
        vc.allowsEditing = AppManager.shared.getIsEdittingValue()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var typeImage = UIImagePickerController.InfoKey.originalImage
        if AppManager.shared.getIsEdittingValue() {
            typeImage = UIImagePickerController.InfoKey.editedImage
        }
        if let image = info[typeImage] as? UIImage {
            if self.userChoice == .mom {
                self.currentModel.avatarImage = image
                self.setupData()
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView?.reloadRows(at: [indexPath], with: .none)
            } else {
                self.currentModel.imagePregnant = image
                self.setupData()
                self.tableView?.reloadData()
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showMore(_ sender: UIButton) {
        if self.currentModel.id == "" {
            let alert = UIAlertController(title: Constant.Text.notification, message: Constant.Text.patientNotSave, preferredStyle: .actionSheet)
            let action = UIAlertAction(title: Constant.Text.saveIt, style: .default) { _ in
                self.saveData()
            }
            let cancel = UIAlertAction(title: Constant.Text.cancel, style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        } else {
            let vc = HistoryViewController.init(nibName: HistoryViewController.className, bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            vc.idUser = currentModel.id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func saveData(_ sender: UIButton) {
        if self.currentModel.id != "" {
            self.updateUser(id: currentModel.id)
        } else {
            self.saveData()
        }
    }
    
    func saveData() {
        if !self.currentModel.name.isEmpty && !self.currentModel.address.isEmpty &&
            !self.currentModel.momBirth.isEmpty && !self.currentModel.height.isEmpty && !self.currentModel.numberPhone.isEmpty {
            self.saveInfoUser()
        } else {
            let alert = UIAlertController(title: Constant.Text.notification, message: Constant.Text.missingInfo, preferredStyle: .actionSheet)
            let action = UIAlertAction(title: Constant.Text.understand, style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openDate() {
        let vc = PopupCalendarViewController.init(nibName: PopupCalendarViewController.className, bundle: nil)
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
        dateFormatter.dateFormat = Constant.Text.dateFormat
        let date = dateFormatter.date(from:dateString)
        guard let timeLast = date?.millisecondsSince1970 else { return }
        let timeToday = todayDate.millisecondsSince1970
        let result = timeLast - timeToday
        self.changeMilisToWeek(milis: result)
    }
    
    func changeMilisToWeek(milis: Int64) {
        let toDay = milis / 86400000
        let ageDay = 280 - Int(toDay)
        let week = Int(ageDay / 7)
        let day = Int(ageDay % 7)
        self.currentModel.dateCalculate = week < 10 ?  "0\(week)W \(day)D" : "\(week)W \(day)D"
    }
    
    func isInValidPhone() {
        let alert = UIAlertController(title: Constant.Text.notification, message: "Số điện thoại không hợp lệ", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: Constant.Text.understand, style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension DetailUserViewController: UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.count
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
            cell.setupData(model: currentModel)
            cell.invalidPhone = { [weak self] in
                self?.isInValidPhone()
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
                let vc = ShowImageDetailViewController.init(nibName: ShowImageDetailViewController.className, bundle: nil)
                vc.imagePath = self?.currentModel.imagePregnantPath ?? ""
                vc.imageData = self?.currentModel.imagePregnant
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

        let alert = UIAlertController(title: Constant.Text.notification, message: "Không được bỏ trống \(typeCellName)", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: Constant.Text.understand, style: .cancel, handler: nil)
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
        self.userChoice = .mom
        self.openLibararies()
    }
    
    func chooseBabyDOB() {
        self.userChoice = .baby
        self.openDate()
    }
    
    func chooseImage() {
        self.userChoice = .baby
        self.openLibararies()
    }
}

extension DetailUserViewController {
    func saveInfoUser() {
        if self.currentModel.numberPhone.isValidPhone() {
            do {
                self.realm.beginWrite()
                currentModel.id = NSUUID().uuidString.lowercased()
                currentUser.idUser = currentModel.id
                currentUser.name = currentModel.name
                currentUser.address = currentModel.address
                currentUser.momBirth = currentModel.momBirth
                currentUser.numberPhone = currentModel.numberPhone
                currentUser.height = currentModel.height
                currentUser.babyDateBorn = currentModel.babyAge
                currentUser.dateSave = getCurrentDate()
                currentUser.note = currentModel.note
                currentUser.avatar = saveImage(imageName: "avatarUser_\(currentModel.id)",
                                               image: currentModel.avatarImage ?? UIImage(named: Constant.Text.avatarPlaceholder)!,
                                               type: .mom)
                currentUser.imagePregnant = saveImage(imageName: "imagePregnant_\(currentModel.id)",
                                                      image: currentModel.imagePregnant ?? nil,
                                                      type: .baby)
                try? self.realm.commitWrite()
                try? self.realm.safeWrite({
                    self.realm.add(currentUser)
                    let alert = UIAlertController(title: Constant.Text.notification, message: "Lưu thành công", preferredStyle: .actionSheet)
                    let action = UIAlertAction(title: Constant.Text.understand, style: .cancel) { _ in
                        self.navigationController?.popToRootViewController(animated: true)
                        Session.shared.isPopToRoot = true
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                })
            }
        } else {
            self.isInValidPhone()
        }
    }
    
    func updateUser(id: String) {
        guard let currentUser = realm.objects(User.self).filter("idUser == %@", id).toArray().first else { return }
        
        try! self.realm.write({
            currentUser.name = currentModel.name
            currentUser.address = currentModel.address
            currentUser.momBirth = currentModel.momBirth
            currentUser.numberPhone = currentModel.numberPhone
            currentUser.height = currentModel.height
            currentUser.babyDateBorn = currentModel.babyAge
            currentUser.dateSave = getCurrentDate()
            currentUser.note = currentModel.note
            if currentUser.avatar.isEmpty {
                currentUser.avatar = saveImage(imageName: "avatarUser_\(id)",
                                               image: currentModel.avatarImage ?? UIImage(named: Constant.Text.avatarPlaceholder)!,
                                               type: .mom)
            } else {
                if let avatar = currentModel.avatarImage {
                    currentUser.avatar = saveImage(imageName: "avatarUser_\(id)",
                                                   image: avatar,
                                                   type: .mom)
                }
            }
            if currentUser.imagePregnant.isEmpty {
                currentUser.imagePregnant = saveImage(imageName: "imagePregnant_\(id)",
                                                      image: currentModel.imagePregnant ?? nil,
                                                      type: .baby)
            } else {
                if let image = currentModel.imagePregnant {
                    currentUser.imagePregnant = saveImage(imageName: "imagePregnant_\(id)",
                                                          image: image,
                                                          type: .baby)
                }
            }
            
            let alert = UIAlertController(title: Constant.Text.notification, message: "Cập nhật thành công", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: Constant.Text.understand, style: .cancel) { _ in
                self.navigationController?.popToRootViewController(animated: true)
                Session.shared.isPopToRoot = true
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        })
    }
}
