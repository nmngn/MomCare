//
//  ViewController.swift
//  MomCare
//
//  Created by Nam Ngây on 04/07/2021.
//

import UIKit
import NotificationCenter
import PopupDialog
import Presentr
import RealmSwift

enum SortType {
    case name
    case date
    case age
    case normal
    
    func toText() -> String {
        switch self {
        case .name: return Constant.Text.sortName
        case .age: return Constant.Text.sortAge
        case .date:  return Constant.Text.sortDate
        default: return ""
        }
    }
}

class HomeViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var theme: UIImageView!
    
    var model = [HomeModel]()
    var listUser: [User]? {
        didSet {
            setupData()
        }
    }
    let realm = try! Realm()
    var sortType: SortType = .normal
    let userNotificationCenter = UNUserNotificationCenter.current()
    var notiModel = [NotificationModel]()
    let asyncMainThread = DispatchQueue.main
    let userInitiatedThread = DispatchQueue.global(qos: .userInitiated)
    let backgroundThread = DispatchQueue.global(qos: .background)
    
    let presenter: Presentr = {
        let customPresenter = Presentr(presentationType: .fullScreen)
        customPresenter.transitionType = .coverHorizontalFromRight
        customPresenter.dismissTransitionType = .coverHorizontalFromRight
        customPresenter.dismissOnSwipe = true
        customPresenter.dismissAnimated = true
        customPresenter.dismissOnSwipeDirection = .default
        return customPresenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.Text.home
        self.userInitiatedThread.async {
            self.changeTheme(self.theme)
        }
        asyncMainThread.async {
            self.getListUser()
            self.userNotificationCenter.delegate = self
            self.requestNotificationAuthorization()
            self.setupNavigationButton()
        }
        self.configView()
        self.navigationController?.isNavigationBarHidden = false
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.changeTheme(self.theme)
        self.setupNavigationButton()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if Session.shared.isPopToRoot {
            self.getListUser()
            Session.shared.isPopToRoot = false
        }
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func setupNavigationButton() {
        let rightItem = UIBarButtonItem(image: UIImage(systemName: Constant.Text.listBullet)?.toHierachicalImage()
                                        , style: .plain, target: self, action: #selector(openMore))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func openMore() {
        let vc = SmallOptionViewController.init(nibName: SmallOptionViewController.className, bundle: nil)
        vc.notiModel = self.notiModel
        vc.navigation = self.navigationController ?? UINavigationController()
        customPresentViewController(presenter, viewController: vc, animated: true)
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    func sendNotification(noti: [NotificationModel]) {
        let application = UIApplication.shared
        let notificationContent = UNMutableNotificationContent()
        if noti.count == 1 {
            notificationContent.title = Constant.Text.notificationAbout + "\(noti.first?.name ?? "")"
            notificationContent.body =
            "Chú ý: \(noti.first?.name ?? "") đã bước vào tháng cuối( \(noti.first?.dateCalculate ?? ""))\nCần chú ý !"
        } else {
            notificationContent.title = Constant.Text.notificationAbout + "\(self.notiModel.count) bệnh nhân tháng cuối"
            notificationContent.body =
            "Chú ý: \(self.notiModel.count) bệnh nhân đã bước vào tháng cuối \nCần chú ý !"
        }
        application.applicationIconBadgeNumber = noti.count
        
        if let url = Bundle.main.url(forResource: Constant.Text.dune,
                                     withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: Constant.Text.dune,
                                                              url: url,
                                                              options: nil) {
                notificationContent.attachments = [attachment]
            }
        }
        
        var date = DateComponents()
        (date.hour, date.minute) = AppManager.shared.getTime()
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: Constant.Text.notificationEn,
                                            content: notificationContent,
                                            trigger: trigger)
        
        if !noti.isEmpty {
            userNotificationCenter.add(request) { (error) in
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let vc = NotificationViewController.init(nibName: NotificationViewController.className, bundle: nil)
        vc.notiModel = self.notiModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
    
    func getUserToPushNoti(listUser: [User]?) {
        self.notiModel.removeAll()
        if let listUser = listUser {
            let newList = listUser.filter ({ user in
                let text = updateTime(dateString: user.babyDateBorn)
                if !text.isEmpty {
                    let wStartIndex = text.index(text.startIndex, offsetBy: 0)
                    let wEndIndex = text.index(text.startIndex, offsetBy: 1)
                    let weekData = String(text[wStartIndex...wEndIndex])
                    
                    let wResult = Int(weekData) ?? 0 >= 38
                    return wResult
                }
                return false
            })
            for user in newList {
                self.notiModel.append(user.convertToNotiModel())
            }
            self.sendNotification(noti: self.notiModel)
        }
    }
    
    func getListUser(reverse: Bool = false) {
        do {
            let list = realm.objects(User.self).toArray()
            self.getUserToPushNoti(listUser: list)
            if !reverse {
                self.listUser = list
            } else {
                self.listUser = list.reversed()
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
            if !user.babyDateBorn.isEmpty {
                let startIndex = user.babyDateBorn.index(user.babyDateBorn.startIndex, offsetBy: 3)
                let endIndex = user.babyDateBorn.index(user.babyDateBorn.startIndex, offsetBy: 4)
                let data = String(user.babyDateBorn[startIndex...endIndex])
                let result = Int(data) ?? 0 == getCurrentMonth()
                return result
            }
            return false
        })
        
        let badge = HomeModel(type: .badge)
        let addUser = HomeModel(type: .addUser)
        
        var header1 = HomeModel(type: .title)
        header1.title = Constant.Text.patientInMonth + "(\(newList.count))"
        
        var infoCell = HomeModel(type: .infoUser)
        let sort = HomeModel(type: .sort)
        
        var header2 = HomeModel(type: .title)
        header2.title = Constant.Text.allPatient + "(\(listUser.count))"
        
        model.append(badge)
        model.append(addUser)
        model.append(header1)
        
        for i in 0..<newList.count {
            infoCell.id = newList[i].idUser
            infoCell.avatarImage = newList[i].avatar
            infoCell.babyAge = newList[i].babyDateBorn
            infoCell.name = newList[i].name
            infoCell.dateSave = newList[i].dateSave
            infoCell.dateCalculate = updateTime(dateString: newList[i].babyDateBorn)
            infoCell.isStar = newList[i].isStar
            model.append(infoCell)
        }
        
        model.append(header2)
        if !listUser.isEmpty {
            model.append(sort)
        }
        
        for i in 0..<listUser.count {
            infoCell.id = listUser[i].idUser
            infoCell.avatarImage = listUser[i].avatar
            infoCell.babyAge = listUser[i].babyDateBorn
            infoCell.name = listUser[i].name
            infoCell.dateSave = listUser[i].dateSave
            infoCell.dateCalculate = updateTime(dateString: listUser[i].babyDateBorn)
            infoCell.isStar = listUser[i].isStar
            model.append(infoCell)
        }
        self.tableView.reloadData()
    }
    
    @IBAction func searchUser(_ sender: UIBarButtonItem) {
        let vc = SearchViewController.init(nibName: SearchViewController.className, bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func modelIndexPath(indexPath: IndexPath) -> HomeModel {
        return model[indexPath.row]
    }
    
    func sortListUser() {
        let alert = UIAlertController(title: Constant.Text.sort, message: Constant.Text.chooseSortType, preferredStyle: .actionSheet)
        let sortName = UIAlertAction(title: Constant.Text.sortName, style: .default, handler: { _ in
            self.sortType = .name
            if let listUser = self.listUser {
                let items = listUser.sorted{$0.name < $1.name}
                self.listUser?.removeAll()
                self.listUser = items
            }
        })
        let sortDateSave = UIAlertAction(title: Constant.Text.sortDate, style: .default, handler: { _ in
            self.sortType = .date
            self.getListUser(reverse: true)
        })
        let sortDateCal = UIAlertAction(title: Constant.Text.sortAge, style: .default, handler: { _ in
            self.sortType = .age
            if let listUser = self.listUser {
                let newList = listUser.sorted(by: {$0.updateTime() >
                    $1.updateTime()})
                self.listUser?.removeAll()
                self.listUser = newList
            }
        })
        let cancel = UIAlertAction(title: Constant.Text.cancel, style: .cancel, handler: { _ in
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BadgeUserTableViewCell.className, for: indexPath) as?
                    BadgeUserTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            if let list = self.listUser {
                cell.getNumberPatient(list: list)
            }
            return cell
        case .addUser:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddUserTableViewCell.className, for: indexPath) as?
                    AddUserTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.setupData()
            return cell
        case .infoUser:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BiggerHomeUserTableViewCell.className, for: indexPath) as?
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SortListTableViewCell.className, for: indexPath) as?
                    SortListTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            self.sortType == .normal ? cell.setupTitle(title: Constant.Text.sort) : cell.setupTitle(title: self.sortType.toText())
            cell.selectSoft = { [weak self] in
                self?.sortListUser()
            }
            return cell
        case .title:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTitleTableViewCell.className, for: indexPath) as?
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
            let vc = DetailUserViewController.init(nibName: DetailUserViewController.className, bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        case .infoUser:
            do {
                let vc = DetailUserViewController.init(nibName: DetailUserViewController.className, bundle: nil)
                vc.currentModel.id = model.id
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }
    
}

extension HomeViewController {
    func saveStarStatus(id: String,_ isStar: Bool) {
        guard let selectedUser = self.realm.objects(User.self).filter("idUser == %@", id).toArray().first else { return }
        try! self.realm.write {
            selectedUser.isStar = isStar
        }
        self.getListUser()
    }
}
