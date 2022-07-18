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
        var account = AccountModel()
        account.type = .info
        account.image = UIImage(systemName: "person")
        account.title = "Thông tin cá nhân"
        
        var logout = AccountModel()
        logout.type = .logout
        logout.image = UIImage(systemName: "rectangle.portrait.and.arrow.right")
        logout.title = "Đăng xuất"
        model.append(account)
        model.append(logout)
    }
    
    func modelIndexPath(indexPath: IndexPath) -> AccountModel {
        return model[indexPath.row]
    }
    
    func popupErrorSignout() {
        let alert = UIAlertController(title: "Lỗi", message: "Đăng xuất lỗi", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func logOut() {
        let alert = UIAlertController(title: "Thông báo", message: "Bạn có muốn đăng xuất không?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Ok", style: .default) { _ in
            self.signOut()
        }
        let noAction = UIAlertAction(title: "Hủy bỏ", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    func signOut() {

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
        case .info:
            break
        case .logout:
            logOut()
        default:
            break
        }
    }
}
