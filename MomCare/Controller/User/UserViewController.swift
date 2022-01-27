//
//  UserViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 22/01/2022.
//

import UIKit
import FirebaseAuth
import SwiftCSV

class UserViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var theme: UIImageView!
    
    var currentModel = UserInfo() {
        didSet {
            tableView.reloadData()
        }
    }
    var model = [UserInfo]()
    var detailData = DetailModel()
    let repo = Repositories(api: .share)
    var data = ""
    var moreData = ""
    var bonusData = "" {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataUser()
        setupData()
        setupNavigationButton()
        configView()
        changeTheme(theme)
        self.title = "Màn hình chính"
    }
    
    func setupNavigationButton() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: true)
        let backItem = UIBarButtonItem(image:  UIImage(systemName: "rectangle.portrait.and.arrow.right")?.toHierachicalImage()
                                       , style: .plain, target: self, action: #selector(logOut))
        navigationItem.leftBarButtonItems = [backItem]

        let rightItem = UIBarButtonItem(image: UIImage(systemName: "message.circle")?.toHierachicalImage()
                                        , style: .plain, target: self, action:
                                        #selector(letChat))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func logOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let storyboard = UIStoryboard(name: "LogInView", bundle: nil)
            if let logInView = storyboard.instantiateViewController(withIdentifier: "LogInViewController") as? LogInViewController {
                navigationController?.pushViewController(logInView, animated: true)
            }
        } catch let signOutError as NSError {
            print(signOutError)
            popupErrorSignout()
        }
    }
    
    @objc func letChat() {
        let vc = ChatViewController.init(nibName: "ChatViewController", bundle: nil)
        vc.detailUser = detailData
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func popupErrorSignout() {
        let alert = UIAlertController(title: "Lỗi", message: "Đăng xuất lỗi", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func getDataUser() {
        let number = Session.shared.userProfile.userNumberPhone
        repo.getDataUserByNumber(numberPhone: number) { [weak self] response in
            switch response {
            case .success(let data):
                if let data = data {
                    self?.currentModel = data.convertToUserModel()
                    self?.detailData = data.convertToDetailModel()
                    self?.getData(week: data.updateTime())
                }
            case .failure(let error):
                print(error as Any)
            }
        }
    }
    
    func setupData() {
        var cell1 = UserInfo()
        cell1.type = .general
        var cell2 = UserInfo()
        cell2.type = .data
        var cell3 = UserInfo()
        cell3.type = .more
        
        model.append(cell1)
        model.append(cell2)
        model.append(cell3)
    }
    
    func configView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.separatorStyle = .none
            $0.tableFooterView = UIView()
            $0.registerNibCellFor(type: UserInfoTableViewCell.self)
            $0.registerNibCellFor(type: DataInfoTableViewCell.self)
            $0.registerNibCellFor(type: MoreInfoTableViewCell.self)
        }
    }

    func modelIndexPath(indexPath: IndexPath) -> UserInfo {
        return model[indexPath.row]
    }
    
    func getData(week: String) {
        let path = Bundle.main.path(forResource: "Book1", ofType: "csv")
        let path2 = Bundle.main.path(forResource: "Book2", ofType: "csv")
        
        var month = 0
        var age = 0
        if !week.isEmpty {
            let startIndex = week.index(week.startIndex, offsetBy: 0)
            let endIndex = week.index(week.startIndex, offsetBy: 1)
            let data = String(week[startIndex...endIndex])
            age = Int(data) ?? 0
            if age > 1 && age <= 5 {
                month = 1
            } else if age > 5 && age <= 9 {
                month = 2
            } else if age > 9 && age <= 13 {
                month = 3
            } else if age >= 14 && age <= 18 {
                month = 4
            } else if age >= 19 && age <= 23 {
                month = 5
            } else if age >= 23 && age <= 27 {
                month = 6
            } else if age > 28 && age <= 32 {
                month = 7
            } else if age > 32 && age <= 36 {
                month = 8
            } else if age > 36 && age <= 40 {
                month = 9
            }
        }
                
        do {
            let csv : CSV = try CSV(url: URL(fileURLWithPath: path!))
            let rows = csv.namedRows
            
            for row in rows {
                if let data = row["\(age)"] {
                    self.data = data
                }
            }
        } catch {
            print("Parsing CSV file has error \(error)")
        }
        
        do {
            let csv: CSV = try CSV(url: URL(fileURLWithPath: path2!))
            let rows = csv.namedRows
            
            for row in rows {
                if let data = row["\(month)"] {
                    self.moreData = data
                }
                if let data = row["-"] {
                    self.bonusData = data
                }
            }
        }catch {
            print("Parsing CSV file has error \(error)")
        }
    }
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model: UserInfo
        model = modelIndexPath(indexPath: indexPath)
        
        switch model.type {
        case .general:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoTableViewCell", for: indexPath) as?
                    UserInfoTableViewCell else { return UITableViewCell()}
            cell.selectionStyle = .none
            cell.setupData(model: currentModel)
            return cell
        case .data:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DataInfoTableViewCell", for: indexPath) as?
                    DataInfoTableViewCell else { return UITableViewCell()}
            cell.selectionStyle = .none
            cell.setupData(text: self.data)
            return cell
        case .more:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MoreInfoTableViewCell", for: indexPath) as?
                    MoreInfoTableViewCell else { return UITableViewCell()}
            cell.selectionStyle = .none
            cell.setupData(text: moreData + bonusData)
            return cell
        default:
            return UITableViewCell()
        }
    }
}
