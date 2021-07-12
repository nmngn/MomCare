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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Màn hình chính"
        configView()
        setupData()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
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
        let badge = HomeModel(type: .badge)
        var header1 = HomeModel(type: .title)
        header1.title = "Dự kiến sinh trong tháng này"
        let biggerCell = HomeModel(type: .biggerUser)
        let sort = HomeModel(type: .sort)
        var header2 = HomeModel(type: .title)
        header2.title = "Tất cả bênh nhân"
        
        model.append(badge)
        model.append(header1)
        model.append(biggerCell)
        model.append(biggerCell)
        model.append(biggerCell)
        model.append(header2)
        model.append(sort)
        model.append(biggerCell)
        model.append(biggerCell)
        model.append(biggerCell)
        model.append(biggerCell)
    }


    @IBAction func searchUser(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func openCalculate(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func addUser(_ sender: UIButton) {
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
            return cell
        case .biggerUser:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BiggerHomeUserTableViewCell", for: indexPath) as?
                    BiggerHomeUserTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
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
        case .biggerUser:
            let vc = DetailUserViewController.init(nibName: "DetailUserViewController", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    
}
