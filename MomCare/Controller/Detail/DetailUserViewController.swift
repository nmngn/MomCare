//
//  DetailUserViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 05/07/2021.
//

import UIKit
import Then
import RealmSwift

class DetailUserViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    var model = [DetailModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        setupData()
        setupBackButton()
        self.title = "Thông tin bệnh nhân"
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
        }
    }
    
    func setupData() {
        var avatar = DetailModel(type: .avatar, dataType: .momImage)
        avatar.image = UIImage(named: "avatar_placeholder")
        
        var general = DetailModel(type: .general, dataType: .dateSave)
        general.date = "20/10/2020 19:25"
        
        var name = DetailModel(type: .info, dataType: .name)
        name.title = "Họ và tên"
        name.value = ""
        
        var address = DetailModel(type: .info, dataType: .address)
        address.title = "Địa chỉ"
        address.value = ""
        
        var birth = DetailModel(type: .info, dataType: .dob)
        birth.title = "Năm sinh"
        birth.value = ""
        birth.showCalendar = true
        
        var number = DetailModel(type: .info, dataType: .numberPhone)
        number.title = "Số điện thoại"
        birth.value = ""
        
        var height = DetailModel(type: .info, dataType: .height)
        height.title = "Chiều cao"
        height.value = ""
        
        let age = DetailModel(type: .age, dataType: .babyAge)
        
        let note = DetailModel(type: .note, dataType: .note)
        
        let photo = DetailModel(type: .photo, dataType: .babyImage)
        
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
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func fromLibrary() {
        openLibararies()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                if image.pngData()?.count ?? 0 >= 12000 * 1000 {
                    self.view.makeToast("Lỗi tải ảnh: Ảnh của bạn có thể sẽ bị thay đổi kích thước do vượt quá dung lượng (5MB).", duration: 1.5, position: .top)
                }
            self.tableView.reloadData()
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
        present(vc, animated: true, completion: nil)
    }
    
    func saveImage(image: UIImage) {
        let realm = try! Realm()
            let model = User()
        

    }
}

extension DetailUserViewController: UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model: DetailModel
        model = modelIndexPath(indexPath: indexPath)
        
        switch model.type {
        case .avatar:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AvatarUserTableViewCell.name, for: indexPath) as?
                    AvatarUserTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.setupData(model: model)
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
            cell.setupData(model: model)
            return cell
        case .age:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BaybyAgeTableViewCell.name, for: indexPath) as?
                    BaybyAgeTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        case .note:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.name, for: indexPath) as?
                    NoteTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            return cell
        case .photo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.name, for: indexPath) as?
                    PhotoTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        }
    }
}

extension DetailUserViewController: DetailUserInfo {
    func saveNote(text: String) {
        
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Thông báo", message: "Không được bỏ trống trường này", preferredStyle: .alert)
        let action = UIAlertAction(title: "Đã hiểu", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendString(dataType: DataType, text: String) {
        
    }
    
    func chooseAvatar() {
        openLibararies()
    }
    
    func chooseDOB() {
        openDate()
    }
    
    func chooseBabyDOB() {
        openDate()
    }
    
    func chooseImage() {
        openLibararies()
    }
}
