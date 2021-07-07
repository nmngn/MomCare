//
//  DetailUserViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 05/07/2021.
//

import UIKit
import Then

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
        let avatar = DetailModel(type: .avatar)
        
        var general = DetailModel(type: .general)
        general.date = "20/10/2020 19:25"
        
        var name = DetailModel(type: .info)
        name.title = "Họ và tên"
        name.value = ""
        
        var address = DetailModel(type: .info)
        address.title = "Địa chỉ"
        address.value = ""
        
        var birth = DetailModel(type: .info)
        birth.title = "Năm sinh"
        birth.value = ""
        
        var number = DetailModel(type: .info)
        number.title = "Số điện thoại"
        birth.value = ""
        
        var height = DetailModel(type: .info)
        height.title = "Chiều cao"
        height.value = ""
        
        let age = DetailModel(type: .age)
        
        let note = DetailModel(type: .note)
        
        let photo = DetailModel(type: .photo)
        
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
}

extension DetailUserViewController: UITableViewDelegate, UITableViewDataSource {
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
            return cell
        case .age:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BaybyAgeTableViewCell.name, for: indexPath) as?
                    BaybyAgeTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
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
            return cell
        }
    }
}
