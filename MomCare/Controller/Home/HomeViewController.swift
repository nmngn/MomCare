//
//  ViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 04/07/2021.
//

import UIKit
import RealmSwift
import NotificationCenter

class HomeViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var theme: UIImageView!
    
    var model = [HomeModel]()
    let realm = try! Realm()
    var listUser: [User]? {
        didSet {
            setupData()
            self.tableView?.reloadData()
        }
    }
    var sortType = ""
    var contrastColor = UIColor()
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Màn hình chính"
        configView()
        userNotificationCenter.delegate = self
        if self.traitCollection.userInterfaceStyle == .light {
            contrastColor = .black
        } else {
            contrastColor = UIColor.white.withAlphaComponent(0.8)
        }
        self.requestNotificationAuthorization()
        self.sendNotification()
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
       return .default
   }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getListUser()
        changeTheme()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }

    func sendNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Test"
        notificationContent.body = "Test body"
        notificationContent.badge = NSNumber(value: 3)
        
        if let url = Bundle.main.url(forResource: "dune",
                                     withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "dune",
                                                              url: url,
                                                              options: nil) {
                notificationContent.attachments = [attachment]
            }
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: "Notification",
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
    
    func changeTheme() {
        DispatchQueue.main.async {
            self.view.backgroundColor = .clear
            let hour = Calendar.current.component(.hour, from: Date())
            if hour < 5 {
                self.theme.image = UIImage(named: "time1")
            } else if hour >= 5 && hour < 7 {
                self.theme.image = UIImage(named: "time2")
            } else if hour >= 7 && hour < 9 {
                self.theme.image = UIImage(named: "time3")
            } else if hour >= 9 && hour < 17 {
                self.theme.image = UIImage(named: "time4")
            } else if hour >= 17 && hour < 19 {
                self.theme.image = UIImage(named: "time5")
            } else if hour >= 19 && hour < 23 {
                self.theme.image = UIImage(named: "time2")
            } else {
                self.theme.image = UIImage(named: "time1")
            }
        }
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
            $0.registerNibCellFor(type: AddUserTableViewCell.self)
            $0.registerNibCellFor(type: BiggerHomeUserTableViewCell.self)
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 48, right: 0)
        }
    }
    
    func setupData() {
        model.removeAll()
        guard let listUser = self.listUser else { return }
        let newList = listUser.filter ({ user in
            let text = updateTime(dateString: user.babyDateBorn)
            if !text.isEmpty {
                let startIndex = text.index(text.startIndex, offsetBy: 0)
                let endIndex = text.index(text.startIndex, offsetBy: 1)
                let data = String(text[startIndex...endIndex])
                let result = Int(data) ?? 0 >= 36
                return result
            }
            return false
        })
        
        var badge = HomeModel(type: .badge)
        badge.contrastColor = contrastColor
        
        var addUser = HomeModel(type: .addUser)
        addUser.contrastColor = contrastColor
        
        var header1 = HomeModel(type: .title)
        header1.title = "Dự kiến sinh trong tháng này(\(newList.count))"
        header1.contrastColor = contrastColor
        
        var infoCell = HomeModel(type: .infoUser)
        infoCell.contrastColor = contrastColor
        
        var sort = HomeModel(type: .sort)
        sort.contrastColor = contrastColor
        
        var header2 = HomeModel(type: .title)
        header2.title = "Tất cả bệnh nhân(\(listUser.count))"
        header2.contrastColor = contrastColor
        
        model.append(badge)
        model.append(addUser)
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
            infoCell.dateCalculate = updateTime(dateString: newList[i].babyDateBorn)
            infoCell.isStar = newList[i].isStar
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
            infoCell.dateCalculate = updateTime(dateString: listUser[i].babyDateBorn)
            infoCell.isStar = listUser[i].isStar
            model.append(infoCell)
        }
    }

    @IBAction func searchUser(_ sender: UIBarButtonItem) {
        let vc = SearchViewController.init(nibName: "SearchViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func openCalculate(_ sender: UIBarButtonItem) {
        let vc = NotificationViewController.init(nibName: "NotificationViewController", bundle: nil)
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
            if let listUser = self.listUser {
                let newList = listUser.sorted(by: {$0.updateTime(dateString: $0.babyDateBorn) >
                    $1.updateTime(dateString: $1.babyDateBorn)})
                self.listUser?.removeAll()
                self.listUser = newList
            }
        })
        let cancel = UIAlertAction(title: "Hủy bỏ", style: .cancel, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(sortName)
        alert.addAction(sortDateSave)
        alert.addAction(sortDateCal)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
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
                cell.getNumberPatient(list: list, contrastColor: self.contrastColor)
            }
            return cell
        case .addUser:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddUserTableViewCell", for: indexPath) as?
                    AddUserTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.setupData(model: model)
            return cell
        case .infoUser:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BiggerHomeUserTableViewCell", for: indexPath) as?
                    BiggerHomeUserTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            DispatchQueue.main.async {
                cell.setupData(model: model)
            }
            cell.isStar = { [weak self] isStar in
                self?.saveStarStatus(id: model.id, isStar)
            }
            return cell
        case .sort:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SortListTableViewCell", for: indexPath) as?
                    SortListTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            self.sortType == "" ? cell.setupTitle(title: "Sắp xếp", contrastColor: self.contrastColor) : cell.setupTitle(title: self.sortType, contrastColor: self.contrastColor)
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
        case .addUser:
            let vc = DetailUserViewController.init(nibName: "DetailUserViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
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

extension HomeViewController {
    func saveStarStatus(id: Int,_ isStar: Bool) {
        let users = realm.objects(User.self).filter("id = %d", id)
        
        if let user = users.first {
            try! realm.write {
                user.isStar = isStar
            }
            self.getListUser()
            self.tableView.reloadData()
        }
    }
    
}
