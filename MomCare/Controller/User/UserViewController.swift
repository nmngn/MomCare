//
//  UserViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 22/01/2022.
//

import UIKit
import FirebaseAuth
import SwiftCSV
import Presentr

class UserViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var theme: UIImageView!
    
    var currentModel = UserInfo()
    var adminData: Admin? {
        didSet {
            tableView.reloadData()
        }
    }
    var model = [UserInfo]()
    var detailData = DetailModel()
    let repo = Repositories(api: .share)
    var data = ""
    var moreData = ""
    var bonusData = ""
    var illuImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Màn hình chính"
        changeTheme(theme)
        getDataUser()
        setupData()
        setupNavigationButton()
        configView()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        changeTheme(theme)
        setupNavigationButton()
        tableView.reloadData()
    }
    
    let presenter: Presentr = {
        let customPresenter = Presentr(presentationType: .fullScreen)
        customPresenter.transitionType = .coverHorizontalFromRight
        customPresenter.dismissTransitionType = .coverHorizontalFromRight
        customPresenter.dismissOnSwipe = true
        customPresenter.dismissAnimated = true
        customPresenter.dismissOnSwipeDirection = .default
        return customPresenter
    }()
    
    func setupNavigationButton() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: true)
        let rightItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet")?.toHierachicalImage()
                                        , style: .plain, target: self, action:
                                        #selector(openPopupUser))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    func getAdminData(idAdmin: String) {
        repo.getOneAdmin(idAdmin: idAdmin) { [weak self] response in
            switch response {
            case .success(let data):
                self?.adminData = data
                Session.shared.userProfile.adminNumber = data?.numberPhone ?? ""
            case .failure(let error):
                print(error as Any)
            }
        }
    }
    
    @objc func openPopupUser() {
        let vc = PopupUserViewController.init(nibName: "PopupUserViewController", bundle: nil)
        vc.detailUser = detailData
        vc.isUserChat = true
        vc.navigation = self.navigationController ?? UINavigationController()
        customPresentViewController(presenter, viewController: vc, animated: true)
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
                    self?.getAdminData(idAdmin: data.idAdmin)
                }
            case .failure(let error):
                print(error as Any)
            }
        }
    }
    
    func setupData() {
        var cell0 = UserInfo()
        cell0.type = .admin
        var cell1 = UserInfo()
        cell1.type = .general
        var cell2 = UserInfo()
        cell2.type = .data
        var cell3 = UserInfo()
        cell3.type = .more
        var cell4 = UserInfo()
        cell4.type = .image
        var cell5 = UserInfo()
        cell5.type = .bonus
        
        model.append(cell0)
        model.append(cell1)
        model.append(cell2)
        model.append(cell3)
        model.append(cell4)
        model.append(cell5)
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
            $0.registerNibCellFor(type: AdminInfoTableViewCell.self)
            $0.registerNibCellFor(type: BonusDataTableViewCell.self)
            $0.registerNibCellFor(type: IlluImageTableViewCell.self)
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
                illuImage = UIImage(named: "thang_1") ?? UIImage()
            } else if age > 5 && age <= 9 {
                month = 2
                illuImage = UIImage(named: "thang_2") ?? UIImage()
            } else if age > 9 && age <= 13 {
                month = 3
                illuImage = UIImage(named: "thang_3") ?? UIImage()
            } else if age >= 14 && age <= 18 {
                month = 4
                illuImage = UIImage(named: "thang_4") ?? UIImage()
            } else if age >= 19 && age <= 23 {
                month = 5
                illuImage = UIImage(named: "thang_5") ?? UIImage()
            } else if age >= 23 && age <= 27 {
                month = 6
                illuImage = UIImage(named: "thang_6") ?? UIImage()
            } else if age > 28 && age <= 32 {
                month = 7
                illuImage = UIImage(named: "thang_7") ?? UIImage()
            } else if age > 32 && age <= 36 {
                month = 8
                illuImage = UIImage(named: "thang_8") ?? UIImage()
            } else if age > 36 && age <= 40 {
                month = 9
                illuImage = UIImage(named: "thang_9") ?? UIImage()
            }
        }
                
        do {
            let csv : CSV = try CSV(url: URL(fileURLWithPath: path!))
            let rows = csv.namedRows
            
            for row in rows {
                if age < 10 {
                    if let data = row["0\(age)"] {
                        self.data = data
                    }
                } else {
                    if let data = row["\(age)"] {
                        self.data = data
                    }
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
        tableView.reloadData()
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
        case .admin:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdminInfoTableViewCell", for: indexPath) as?
                    AdminInfoTableViewCell else { return UITableViewCell()}
            cell.selectionStyle = .none
            if let admin = adminData {
                cell.setupData(data: admin)
            }
            return cell
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
            cell.setupData(text: data)
            return cell
        case .more:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MoreInfoTableViewCell", for: indexPath) as?
                    MoreInfoTableViewCell else { return UITableViewCell()}
            cell.selectionStyle = .none
            cell.setupData(text: moreData)
            return cell
        case .image:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "IlluImageTableViewCell", for: indexPath) as?
                    IlluImageTableViewCell else { return UITableViewCell()}
            cell.selectionStyle = .none
            cell.setupImage(image: illuImage)
            return cell
        case .bonus:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BonusDataTableViewCell", for: indexPath) as?
                    BonusDataTableViewCell else { return UITableViewCell()}
            cell.selectionStyle = .none
            cell.setupData(text: bonusData)
            return cell
        default:
            return UITableViewCell()
        }
    }
}
