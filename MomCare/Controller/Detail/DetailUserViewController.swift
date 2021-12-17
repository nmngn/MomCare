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
    var userChoice: UserChoice?
    var currentModel = DetailModel()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        setupData()
        setupBackButton()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "trash.fill"),
                                                                      style: .plain,
                                                                      target: self,
                                                                      action: #selector(removeUser))

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
    
    @objc func removeUser() {
        
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
        let vc = HistoryViewController.init(nibName: "HistoryViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func saveData(_ sender: UIButton) {
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
        self.currentModel.dateCalculate = "\(week)W \(day)D"
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
        do {
            realm.beginWrite()
            if let image = currentModel.avatarImage {
                if image != UIImage(named: "avatar_placeholder") {
                    user.avatar = currentModel.saveImage(imageName: "\(currentModel.numberPhone)", image: image)
                }
            }
            
            if let image = currentModel.imagePregnant {
                user.imagePregnant = currentModel.saveImage(imageName: "\(currentModel.numberPhone)2", image: image)
            }
            
            user.name = currentModel.name
            user.address = currentModel.address
            user.momBirth = currentModel.momBirth
            user.numberPhone = currentModel.numberPhone
            user.height = currentModel.height
            user.babyDateBorn = currentModel.babyAge
            user.dateCalculate = currentModel.dateCalculate
            user.note = currentModel.note
            
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
            let date = Date()
            let dateString = dateFormatter.string(from: date)
            
            user.dateSave = dateString
            
            try? realm.commitWrite()
            try? realm.safeWrite({
                realm.add(user)
                let alert = UIAlertController(title: "Thông báo", message: "Lưu thành công", preferredStyle: .actionSheet)
                let action = UIAlertAction(title: "Đã hiểu", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true) {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }

}
