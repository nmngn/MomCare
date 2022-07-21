//
//  AccountViewController.swift
//  MomCare
//
//  Created by Nam Nguyễn on 13/07/2022.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet private var theme: UIImageView!
    @IBOutlet private var tableView: UITableView!
    
    var model = [AccountModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cá nhân"
        configView()
        setupData()
        changeTheme(theme)
    }
    
    func configView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.separatorStyle = .none
            $0.tableFooterView = UIView()
            $0.registerNibCellFor(type: AccountTableViewCell.self)
        }
    }

    func setupData() {
        var setting = AccountModel()
        setting.type = .setting
        setting.image = UIImage(systemName: "circle.hexagonpath")?.toHierachicalImage()
        setting.title = "Cài đặt"
        
        var notiSetting = AccountModel()
        notiSetting.type = .notiSetting
        notiSetting.image = UIImage(systemName: "bell.badge")?.toHierachicalImage()
        notiSetting.title = "Cài đặt thông báo"
        
        model.append(setting)
        model.append(notiSetting)
    }
    
    func modelIndexPath(indexPath: IndexPath) -> AccountModel {
        return model[indexPath.row]
    }
    
}

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model: AccountModel
        model = modelIndexPath(indexPath: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTableViewCell", for: indexPath) as?
                AccountTableViewCell else { return UITableViewCell()}
        cell.setupData(data: model)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model: AccountModel
        model = modelIndexPath(indexPath: indexPath)
        
        switch model.type {
        case .setting:
            break
        case .notiSetting:
            break
        default:
            break
        }
    }
}
