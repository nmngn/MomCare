//
//  ViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 04/07/2021.
//

import UIKit
import Then

class HomeViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    var model = [HomeModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Màn hình chính"
        configView()
        setupData()
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
        let header1 = HomeModel(type: .title)
        let biggerCell = HomeModel(type: .biggerUser)
        let sort = HomeModel(type: .sort)
        
        model.append(badge)
        model.append(header1)
        model.append(biggerCell)
        model.append(biggerCell)
        model.append(biggerCell)
        model.append(header1)
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
            return cell
        }
    }
    
    
}
