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
import UserNotifications

enum UserChoice {
    case mom
    case baby
}

class DetailUserViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveButton: UIButton!
    
    var model = [DetailModel]()
    var userChoice: UserChoice?
    var currentModel = DetailModel()
    let currentUser = User()
    let realm = try! Realm()
    let asyncMainThread = DispatchQueue.main
    var isEnableRightButton = true
    var infoNotification: (title: String, content: String) = ("", "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.Text.patientInfo
        self.getInfoUser()
        self.asyncMainThread.async {
            self.setupView()
        }
        self.configView()
        self.setupData()
        self.setupNavigationButton()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.setupNavigationButton()
        self.tableView.reloadData()
    }
    
    func getInfoUser() {
        guard let data = realm.objects(User.self).first(where: {$0.idUser == currentModel.id}) else {
            if let data = realm.objects(UserBornModel.self).first(where: {$0.idUser == currentModel.id}) {
                self.currentModel = data.convertToDetailModel()
                self.isEnableRightButton = false
            }
            return
        }
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
            self.showConfirmAlert(title: Constant.Text.notification,
                                  message: Constant.Text.patientNotSave,
                                  confirmTitle: Constant.Text.saveIt) {[weak self] in
                self?.saveData()
            }
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
        
        self.showNoticeAlert(title: Constant.Text.notification, message: "Không được bỏ trống \(typeCellName)")
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
            try? self.realm.safeWrite({[weak self] in
                guard let self = self else { return }
                self.realm.add(currentUser)
                self.showNoticeAlert(title: Constant.Text.notification, message: Constant.Text.notification) {[weak self] in
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            })
        }
    }
    
    func updateUser(id: String) {
        guard let currentUser = realm.objects(User.self).filter("idUser == %@", id).toArray().first else { return }
        
        try! self.realm.safeWrite ({[weak self] in
            guard let self = self else { return }
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
            
            self.showNoticeAlert(title: Constant.Text.notification, message: "Cập nhật thành công") {[weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }
        })
    }
}
