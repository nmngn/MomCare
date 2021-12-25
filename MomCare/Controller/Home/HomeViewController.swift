//
//  ViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 04/07/2021.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    var model = [HomeModel]()
    let realm = try! Realm()
    var listUser: [User]? {
        didSet {
            setupData()
            self.tableView?.reloadData()
        }
    }
    var sortType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Màn hình chính"
        configView()
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getListUser()
    }
    
    func getListUser(reverse: Bool = false) {
        do {
            if !reverse {
                let info = realm.objects(User.self).toArray()
                self.listUser = info
            } else {
                let info = realm.objects(User.self).toArray()
                self.listUser = info.reversed()
            }
        }
    }
    
    func configView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.tableFooterView = UIView()
            $0.separatorStyle = .none
            $0.registerNibCellFor(type: BadgeUserTableViewCell.self)
            $0.registerNibCellFor(type: HomeTitleTableViewCell.self)
            $0.registerNibCellFor(type: SortListTableViewCell.self)
            $0.registerNibCellFor(type: BiggerHomeUserTableViewCell.self)
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 48, right: 0)
        }
    }
    
    func setupData() {
        model.removeAll()
        guard let listUser = self.listUser else { return }
        let newList = listUser.filter ({ user in
            let text = user.dateCalculate
            if !text.isEmpty {
                let startIndex = text.index(text.startIndex, offsetBy: 0)
                let endIndex = text.index(text.startIndex, offsetBy: 1)
                let data = String(text[startIndex...endIndex])
                let result = Int(data) ?? 0 >= 36
                return result
            }
            return false
        })
        
        let badge = HomeModel(type: .badge)
        var header1 = HomeModel(type: .title)
        header1.title = "Dự kiến sinh trong tháng này(\(newList.count))"
        var infoCell = HomeModel(type: .infoUser)
        let sort = HomeModel(type: .sort)
        var header2 = HomeModel(type: .title)
        header2.title = "Tất cả bệnh nhân(\(listUser.count))"
        
        model.append(badge)
        model.append(header1)
        
        for i in 0..<newList.count {
            infoCell.id = newList[i].id
            infoCell.address = newList[i].address
            infoCell.avatarImage = newList[i].avatar
            infoCell.babyAge = newList[i].babyDateBorn
            infoCell.height = newList[i].height
            infoCell.note = newList[i].note
            infoCell.momBirth = newList[i].momBirth
            infoCell.imagePregnant = newList[i].imagePregnant
            infoCell.numberPhone = newList[i].numberPhone
            infoCell.name = newList[i].name
            infoCell.dateSave = newList[i].dateSave
            infoCell.dateCalculate = newList[i].dateCalculate
            model.append(infoCell)
        }
        
        model.append(header2)
        model.append(sort)
        
        for i in 0..<listUser.count {
            infoCell.id = listUser[i].id
            infoCell.address = listUser[i].address
            infoCell.avatarImage = listUser[i].avatar
            infoCell.babyAge = listUser[i].babyDateBorn
            infoCell.height = listUser[i].height
            infoCell.note = listUser[i].note
            infoCell.momBirth = listUser[i].momBirth
            infoCell.imagePregnant = listUser[i].imagePregnant
            infoCell.numberPhone = listUser[i].numberPhone
            infoCell.name = listUser[i].name
            infoCell.dateSave = listUser[i].dateSave
            infoCell.dateCalculate = listUser[i].dateCalculate
            model.append(infoCell)
        }
    }

    @IBAction func searchUser(_ sender: UIBarButtonItem) {
        let vc = SearchViewController.init(nibName: "SearchViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func openCalculate(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func addUser(_ sender: UIButton) {
        let vc = DetailUserViewController.init(nibName: "DetailUserViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func modelIndexPath(indexPath: IndexPath) -> HomeModel {
        return model[indexPath.row]
    }
    
    func sortListUser() {
        let alert = UIAlertController(title: "Sắp xếp", message: "Chọn cách sắp xếp", preferredStyle: .actionSheet)
        let sortName = UIAlertAction(title: "Theo tên", style: .default, handler: { _ in
            self.sortType = "Theo tên"
            let items = self.realm.objects(User.self).sorted(byKeyPath: "name", ascending: true)
            self.listUser?.removeAll()
            self.listUser = items.toArray()
            })
        let sortDateSave = UIAlertAction(title: "Theo ngày lưu", style: .default, handler: { _ in
            self.sortType = "Theo ngày lưu"
            self.getListUser(reverse: true)
        })
        let sortDateCal = UIAlertAction(title: "Theo tuổi tuần thai", style: .default, handler: { _ in
            self.sortType = "Theo tuổi tuần thai"
            let items = self.realm.objects(User.self).sorted(byKeyPath: "dateCalculate", ascending: false)
            self.listUser?.removeAll()
            self.listUser = items.toArray()
        })
        let cancel = UIAlertAction(title: "Hủy bỏ", style: .cancel, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(sortName)
        alert.addAction(sortDateSave)
        alert.addAction(sortDateCal)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: {
            self.tableView.reloadData()
        })
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model: HomeModel
        model = modelIndexPath(indexPath: indexPath)
        
        switch model.type {
        case .badge:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BadgeUserTableViewCell", for: indexPath) as?
                    BadgeUserTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            if let list = self.listUser {
                cell.getNumberPatient(list: list)
            }
            return cell
        case .infoUser:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BiggerHomeUserTableViewCell", for: indexPath) as?
                    BiggerHomeUserTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            DispatchQueue.main.async {
                cell.setupData(model: model)
            }
            return cell
        case .sort:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SortListTableViewCell", for: indexPath) as?
                    SortListTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            self.sortType == "" ? cell.setupTitle(title: "Sắp xếp") : cell.setupTitle(title: self.sortType)
            cell.selectSoft = { [weak self] in
                self?.sortListUser()
            }
            return cell
        case .title:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTitleTableViewCell", for: indexPath) as?
                    HomeTitleTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.setupData(model: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model: HomeModel
        model = modelIndexPath(indexPath: indexPath)
        
        switch model.type {
        case .infoUser:
            let vc = DetailUserViewController.init(nibName: "DetailUserViewController", bundle: nil)
            vc.currentModel = model.convertToDetailModel()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
}
