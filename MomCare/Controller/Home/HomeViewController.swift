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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Màn hình chính"
        configView()
        getListUser()
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
    }
    
    func getListUser() {
        do {
            let info = realm.objects(User.self).toArray()
            self.listUser = info
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
        }
    }
    
    func setupData() {
        model.removeAll()
        guard let listUser = self.listUser else { return }

        let badge = HomeModel(type: .badge)
        var header1 = HomeModel(type: .title)
        header1.title = "Dự kiến sinh trong tháng này"
        var infoCell = HomeModel(type: .infoUser)
        let sort = HomeModel(type: .sort)
        var header2 = HomeModel(type: .title)
        header2.title = "Tất cả bênh nhân(\(listUser.count))"
        
        model.append(badge)
        model.append(header1)
        model.append(header2)
        model.append(sort)
        
        for i in 0..<listUser.count {
            infoCell.avatarImage = listUser[i].avatar
            infoCell.name = listUser[i].name
            infoCell.dateSave = listUser[i].dateSave
            infoCell.dateCalculate = listUser[i].dateCalculate
            model.append(infoCell)
        }
    }

    @IBAction func searchUser(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func openCalculate(_ sender: UIBarButtonItem) {
        getListUser()
    }
    
    @IBAction func addUser(_ sender: UIButton) {
        let vc = DetailUserViewController.init(nibName: "DetailUserViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func modelIndexPath(indexPath: IndexPath) -> HomeModel {
        return model[indexPath.row]
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
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
}
